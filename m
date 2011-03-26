Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1CZFCP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 01:02:15 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:48870 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab1CZFCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 01:02:14 -0400
Date: Sat, 26 Mar 2011 01:01:38 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86 APM: delete Linux kernel APM support
In-reply-to: <20110325113048.GC29521@elte.hu>
Message-id: <alpine.LFD.2.02.1103260036300.28928@x980>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <20110324154505.934a56a0.sfr@canb.auug.org.au>
 <alpine.LFD.2.02.1103240336590.4529@x980>
 <alpine.LFD.2.02.1103240414450.4529@x980> <20110324083959.GE30812@elte.hu>
 <alpine.LFD.2.02.1103241929450.16085@x980> <20110325113048.GC29521@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Regardless of removal, i'd suggest a "this code is not supported" kind of 
> WARN() message to the APM code today, into .39 - to see whether it pops up 
> anywhere - and mark it for -stable as well.

Okay, can do.

> .42 removal might be too fast, considering the typical release schedule of 
> Linux distributions. And i'm still doubting the removal itself: we are adding 
> lots of special-purpose subarch drivers to arch/x86/ as we speak (the embedded 
> mess coming to x86) - which drivers will be tomorrow's APM code. On what 
> grounds do we treat APM support differently?
>
> Our general compatibility with old hardware is an *asset* that we should value.

My guess is that the customers have died off,
and so the code is no longer an asset, but a maintenance liability.

If there is a buzzing community of people running 2011
linux kernels on their ancient laptops in APM mode,
then the APM maintainer would probably know about them.

Personally, my oldest usable laptop is a T23 from March 2002.
It supports APM and ACPI (it shipped with Win2K).
Linux works well on it in ACPI mode, but doesn't even boot in APM mode.
If anybody was really using the latest kernel in APM mode,
I suspect this laptop would boot...

Is there somebody on LKML that has a older laptop than me
and is able to get it to boot in APM mode?  I'd be astonished
if there was not.  Are they willing to regularly test changes
to the upstream kernel to make sure that APM still works?
If yes, where have they been for the last 5 years?

I suspect when there is nobody using the latest kernel on mrst,
then the latest kernel can delete support for mrst, and nobody will care.
Like APM, it will probably undergo "maintenance without testing",
aka bit rot, for a period before that happens.

cheers,
-Len
