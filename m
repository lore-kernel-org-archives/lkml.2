Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab2A3Jz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 04:55:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50093 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab2A3Jzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 04:55:55 -0500
Date: Mon, 30 Jan 2012 10:55:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael D Labriola <michael.d.labriola@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Michael D Labriola <mlabriol@gdeb.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, reboot: reduce to a single DMI table for reboot
 quirks
Message-ID: <20120130095537.GA8924@elte.hu>
References: <87ty3eb9c9.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ty3eb9c9.fsf@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've applied your first two patches, thanks Michael!

Regarding this patch, it does not apply cleanly to the latest 
x86 tree:

 2 out of 5 hunks FAILED -- rejects in file arch/x86/kernel/reboot.c

which you can pick up from:

 git pull git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git master

Also, a style nit, these comments:

> +	/* Write zero to CMOS register number 0x0f, which the BIOS POST
> +	   routine will recognize as telling it to do a proper reboot.  (Well
> +	   that's what this book in front of me says -- it may only apply to
> +	   the Phoenix BIOS though, it's not clear).  At the same time,
> +	   disable NMIs by setting the top bit in the CMOS address register,
> +	   as we're about to do peculiar things to the CPU.  I'm not sure if
> +	   `outb_p' is needed instead of just `outb'.  Use it to be on the
> +	   safe side.  (Yes, CMOS_WRITE does outb_p's. -  Paul G.)
> +	 */

and the other similar comments that you move should be coverted 
to the customary (multi-line) comment style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

I realize that you only move code here - but it's worth cleaning 
it up a bit when touching it.

Thanks,

        Ingo
