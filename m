Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab2A3NxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:53:03 -0500
Received: from mx1.gd-ms.com ([153.11.250.40]:39375 "EHLO mx1.gd-ms.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab2A3NxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:53:01 -0500
X-Greylist: delayed 985 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jan 2012 08:53:01 EST
In-Reply-To: <20120130095537.GA8924@elte.hu>
References: <87ty3eb9c9.fsf@gmail.com> <20120130095537.GA8924@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Michael D Labriola <michael.d.labriola@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] x86, reboot: reduce to a single DMI table for reboot quirks
X-KeepSent: E2532E18:A9BD6FEB-85257995:004A4456;
 type=4; name=$KeepSent
Message-ID: <OFE2532E18.A9BD6FEB-ON85257995.004A4456-85257995.004ABE7E@gdeb.com>
From: Michael D Labriola <mlabriol@gdeb.com>
Date: Mon, 30 Jan 2012 08:36:24 -0500
X-GDMEncrypt: FALSE
X-GDMMarking: NOT_SENSITIVE
Content-Type: text/plain; charset="US-ASCII"
X-GDM-EVAL: score: /30; hits: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

12345678901234567890123456789012345678901234567890123456789012345678901234567890
         1         2         3         4         5         6         7  8

Ingo Molnar <mingo@elte.hu> wrote on 01/30/2012 04:55:37 AM:

> I've applied your first two patches, thanks Michael!

Excellent!

> Regarding this patch, it does not apply cleanly to the latest 
> x86 tree:
> 
>  2 out of 5 hunks FAILED -- rejects in file arch/x86/kernel/reboot.c
> 
> which you can pick up from:
> 
>  git pull git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git 
master

Ok, I based all of them off v3.2.  I'll rebase off of tip tonight after
the kids are in bed.  ;-)

> Also, a style nit, these comments:
> 
> > +   /* Write zero to CMOS register number 0x0f, which the BIOS POST
> > +      routine will recognize as telling it to do a proper reboot. 
(Well
> > +      that's what this book in front of me says -- it may only apply 
to
> > +      the Phoenix BIOS though, it's not clear).  At the same time,
> > +      disable NMIs by setting the top bit in the CMOS address 
register,
> > +      as we're about to do peculiar things to the CPU.  I'm not sure 
if
> > +      `outb_p' is needed instead of just `outb'.  Use it to be on the
> > +      safe side.  (Yes, CMOS_WRITE does outb_p's. -  Paul G.)
> > +    */
> 
> and the other similar comments that you move should be coverted 
> to the customary (multi-line) comment style:
> 
>   /*
>    * Comment .....
>    * ...... goes here.
>    */
> 
> specified in Documentation/CodingStyle.
> 
> I realize that you only move code here - but it's worth cleaning 
> it up a bit when touching it.

You are requesting that I clean up only the comments that appear in the
diff, correct?  I'll do that as well.

---
Michael D Labriola
Electric Boat
mlabriol@gdeb.com
401-848-8871 (desk)
401-848-8513 (lab)
401-316-9844 (cell)


 

