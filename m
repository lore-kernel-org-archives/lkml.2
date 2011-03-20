Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab1CTXGE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 19:06:04 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58353 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676Ab1CTXGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 19:06:00 -0400
X-Sasl-enc: tdzrH8+lcNgHJ3HgJy1ohESztWT5a42bTgHmdO6vkdO4 1300662359
References: <fuopaigyaypsqveewtjx@pwmq> <4D864A82.4090104@fastmail.fm> <20110320215826.79cadfe2@lxorguk.ukuu.org.uk>
User-Agent: K-9 Mail for Android
In-Reply-To: <20110320215826.79cadfe2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: 'scheduling while atomic' during ppp connection on 2.6.37.1 and 2.6.38
From: Jack Stone <jwjstone@fastmail.fm>
Date: Sun, 20 Mar 2011 23:05:46 +0000
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mac <kmac@poczta.fm>, linux-kernel@vger.kernel.org,
        linux-ppp@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Message-ID: <6627fbdd-cce6-4717-8920-3a0d7526274b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>> +        spin_lock_irqsave(&dc->spin_mutex, flags);
>>           if (port->port.count)
>>               room = kfifo_avail(&port->fifo_ul);
>> -        mutex_unlock(&port->tty_sem);
>> +        spin_unlock_irqrestore(&dc->spin_mutex, flags);
>
>dc->spin_mutex does not protect port->port.count.

Sorry if I'm being stupid here but do you mean that port->port.count is modified outside of dc->spin_mutex or that dc->spin_mutex should not be used to protect port->port.count?

I replaced all instances of the port->tty_sem with dc->spin_mutex and port->port.count is only used if dc is non null.

The only other possible problem I see with the change is that the new locking does not allow sleeping in places where it could sleep and disabled irqs where they were not disabled before.

Thank you for your time,

Jack


-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
