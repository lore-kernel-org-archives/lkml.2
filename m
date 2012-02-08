Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab2BHNFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 08:05:49 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42625 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855Ab2BHNFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 08:05:47 -0500
Date: Wed, 8 Feb 2012 14:05:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Bowler <nbowler@elliptictech.com>,
        Randy Dunlap <rdunlap@xenotime.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: MCE, AMD: Hide smp-only code around CONFIG_SMP
Message-ID: <20120208130541.GA2613@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Kevin Winchester <kjwinchester@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Nick Bowler <nbowler@elliptictech.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>
References: <1328209817-18913-1-git-send-email-bp@alien8.de>
 <20120202193702.GA9502@elliptictech.com>
 <20120202202427.GA2234@x1.osrc.amd.com>
 <20120203191801.GA2846@x1.osrc.amd.com>
 <20120207095746.GH15359@elte.hu>
 <20120208101956.GA1772@x1.osrc.amd.com>
 <CAELBVzADZwY61+RWBudFqO7Sb6cs+1GoWe6k+-Zw+wP_Di46og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAELBVzADZwY61+RWBudFqO7Sb6cs+1GoWe6k+-Zw+wP_Di46og@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 08:22:11AM -0400, Kevin Winchester wrote:
> Does this work?  arch/x86/kernel/cpu/mcheck/mce_amd.c includes
> <linux/smp.h> rather than <asm/smp.h> directly.  And <linux/smp.h>
> only includes <asm/smp.h> for the CONFIG_SMP case.  Or perhaps one of
> the other includes in mce_amd.c includes <asm/smp.h>?

It looks like it:

$ make arch/x86/kernel/cpu/mcheck/mce_amd.i
$ grep 'asm/smp.h' arch/x86/kernel/cpu/mcheck/mce_amd.i
# 1 "/home/boris/kernel/linux-2.6/arch/x86/include/asm/smp.h" 1
# 13 "/home/boris/kernel/linux-2.6/arch/x86/include/asm/smp.h"
# 14 "/home/boris/kernel/linux-2.6/arch/x86/include/asm/smp.h" 2
# 16 "/home/boris/kernel/linux-2.6/arch/x86/include/asm/smp.h" 2

and this one pulls in the cpu_llc* crap.

# 183 "/home/boris/kernel/linux-2.6/arch/x86/include/asm/smp.h"
# 225 "/home/boris/kernel/linux-2.6/arch/x86/include/asm/smp.h"
# 236 "/home/boris/kernel/linux-2.6/arch/x86/include/asm/smp.h"

So some other headers seem to pull in asm/smp.h.

HTH.

-- 
Regards/Gruss,
Boris.
