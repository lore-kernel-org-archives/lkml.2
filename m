Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab2IUXNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 19:13:16 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:47076 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758308Ab2IUXNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 19:13:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+dOae1FPe5YIfSSBxox5sW
Date: Fri, 21 Sep 2012 16:13:12 -0700
From: Tony Lindgren <tony@atomide.com>
To: Mark Jackson <mpfj-list@mimc.co.uk>
Cc: linux-omap@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: gpmc_cs_request() causes early boot hang
Message-ID: <20120921231312.GO28835@atomide.com>
References: <505CBFAA.3080604@mimc.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505CBFAA.3080604@mimc.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mark Jackson <mpfj-list@mimc.co.uk> [120921 12:29]:
> I'm developing a beaglebone cape board which requires the use of a
> GPMC chip select.
> 
> I've chosen GPMC_CS0, and in board-am335xevm.c, I have added the following:-
> 
> static void gpmc_test()
> {
>     unsigned long base = 0x12345678;
>     gpmc_cs_request(0, SZ_16M, &base);
>     printk(KERN_INFO "gpmc base @ 0x%08lx\n", base);
> }
> 
> ... and added a call to gpmc_test() at the end of am335x_evm_init().
> 
> If I try to run this code, the kernel fails to boot, and simply hangs at:-
> 
> Uncompressing Linux... done, booting the kernel.
> 
> If I comment out the call to gpmc_cs_request(), the system boots as
> expected (but without my required cs).
> 
> I've looked at the use of this call in other board files, and can't
> see that their code does anything special so I'm stuck on why this
> simple code fails to work.
> 
> Can anyone shed light on what I'm doing wrong ?
> 
> Do I have to initialise the gpmc beforehand in some way ?

Can you enable DEBUG_LL + EARLYPRINTK and have earlyprintk in your
cmdline? You may then get some error messages providing more info.

GPMC is working on many boards with various devices like smsc911x,
onenand, tusb etc.

Regards,

Tony
