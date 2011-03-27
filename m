Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab1C0Vk6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 17:40:58 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:37424 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750968Ab1C0Vk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 17:40:57 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] x86 APM: delete Linux kernel APM support
Date: Sun, 27 Mar 2011 23:40:31 +0200
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
        x86@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.2.02.1103232321070.3848@x980> <20110325113048.GC29521@elte.hu> <alpine.LFD.2.02.1103260036300.28928@x980>
In-Reply-To: <alpine.LFD.2.02.1103260036300.28928@x980>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103272340.42748.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 March 2011 06:01:38 Len Brown wrote:
> > Regardless of removal, i'd suggest a "this code is not supported" kind of
> > WARN() message to the APM code today, into .39 - to see whether it pops
> > up anywhere - and mark it for -stable as well.
>
> Okay, can do.
>
> > .42 removal might be too fast, considering the typical release schedule
> > of Linux distributions. And i'm still doubting the removal itself: we are
> > adding lots of special-purpose subarch drivers to arch/x86/ as we speak
> > (the embedded mess coming to x86) - which drivers will be tomorrow's APM
> > code. On what grounds do we treat APM support differently?
> >
> > Our general compatibility with old hardware is an *asset* that we should
> > value.
>
> My guess is that the customers have died off,
> and so the code is no longer an asset, but a maintenance liability.
>
> If there is a buzzing community of people running 2011
> linux kernels on their ancient laptops in APM mode,
> then the APM maintainer would probably know about them.
>
> Personally, my oldest usable laptop is a T23 from March 2002.
> It supports APM and ACPI (it shipped with Win2K).
> Linux works well on it in ACPI mode, but doesn't even boot in APM mode.
> If anybody was really using the latest kernel in APM mode,
> I suspect this laptop would boot...
>
> Is there somebody on LKML that has a older laptop than me
> and is able to get it to boot in APM mode?  I'd be astonished
> if there was not.  Are they willing to regularly test changes
> to the upstream kernel to make sure that APM still works?
> If yes, where have they been for the last 5 years?

I just tested 2.6.38-rc4 on a desktop board and it works (power off at least). 
If using Grub2, linux16 command must be used instead of linux in grub.cfg 
(otherwise loading apm module will fail with "apm: BIOS not found").

I also have some working laptops with APM but haven't tried recent kernels 
yet.

> I suspect when there is nobody using the latest kernel on mrst,
> then the latest kernel can delete support for mrst, and nobody will care.
> Like APM, it will probably undergo "maintenance without testing",
> aka bit rot, for a period before that happens.

-- 
Ondrej Zary
