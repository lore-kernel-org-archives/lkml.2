Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1KGMUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:20:20 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:33354 "EHLO
	dnet.ilyx.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab1KGMUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:20:19 -0500
Message-ID: <4EB7CCFF.5090304@ilyx.ru>
Date: Mon, 07 Nov 2011 16:20:15 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110929 Iceape/2.0.11
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Race condition in tty buffer's function flush_to_ldisc().
References: <4EB7BD9A.7070600@ilyx.ru> <20111107115802.23201d45@bob.linux.org.uk>
In-Reply-To: <20111107115802.23201d45@bob.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

> On Mon, 07 Nov 2011 15:14:34 +0400
> Ilya Zykov <ilya@ilyx.ru> wrote:
> 
>> Function flush_to_ldisc() call disc->ops->receive_buf(),
>> without tty->buf.lock and with TTY_FLUSHING bit set.
> 
> flush_to_ldisc is single threaded for a given tty. If you fail to
> ensure that is the case everything breaks.

I think so. But if add in flush_to_ldisc():

if (!test_and_set_bit(TTY_FLUSHING, &tty->flags)) {
	.....
} else
	prink...
In my syslog appear this prink on pty devices.

> 
> What cases does this occur ?
> 
> Also for the other patches do you have benchmarks yet ?
> 
> Alan
> 


