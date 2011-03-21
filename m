Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1CUR6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:58:36 -0400
Received: from realvnc.com ([146.101.152.142]:47608 "EHLO realvnc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab1CUR6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:58:35 -0400
Message-ID: <4D8791C9.1080407@realvnc.com>
Date: Mon, 21 Mar 2011 17:58:33 +0000
From: Toby Gray <toby.gray@realvnc.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: cdc-acm: Prevent data loss when filling tty buffer.
References: <1300722745-2404-1-git-send-email-toby.gray@realvnc.com> <20110321165612.0f764046@lxorguk.ukuu.org.uk>
In-Reply-To: <20110321165612.0f764046@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/2011 16:56, Alan Cox wrote:
> On Mon, 21 Mar 2011 15:52:25 +0000
> Toby Gray<toby.gray@realvnc.com>  wrote:

>> This patch adds checking for how many bytes have been inserted into the tty
>> buffer and returns any remaining bytes back to the filled read buffer list.
> How does ACM handle flow control - is the expectation that it gets flow
> controlled in hardware by not having the opportunity to send bits
> to the host end ? If so this seems to make sense.
Yes, the expectation is that it is flow controlled in hardware if a bulk 
endpoint is used. To this end cdc-acm.ko doesn't issue any new read 
requests while the tty is throttled. This works as flow control most of 
the time, but not when the data is arriving quickly (a few megabytes per 
second).

Thank you for your other comments. I had initially gone for the memmove 
thinking that having a buffer head as well as a base would have 
needlessly complicated the rest of the code.

Having made the required changes it seems I'd greatly overestimated the 
changes and it is definitely far cleaner without the memmove.

Regards,

Toby
