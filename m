Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2BVJ2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:28:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43046 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab2BVJ16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:27:58 -0500
Date: Wed, 22 Feb 2012 10:27:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] x86: Move per cpu cpu_llc_shared_map to a field
 in struct cpuinfo_x86
Message-ID: <20120222092745.GA30339@elte.hu>
References: <20120221153935.GE2486@x1.osrc.amd.com>
 <1329875144-560-1-git-send-email-kjwinchester@gmail.com>
 <1329875144-560-2-git-send-email-kjwinchester@gmail.com>
 <4F448DBD.6030300@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F448DBD.6030300@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 02/21/2012 05:45 PM, Kevin Winchester wrote:
> > Commit 141168c36cde ("x86: Simplify code by removing a !SMP #ifdefs from
> > 'struct cpuinfo_x86'") caused the compilation error:
> > 
> > mce_amd.c:(.cpuinit.text+0x4723): undefined reference to 'cpu_llc_shared_map'
> > 
> > by removing an #ifdef CONFIG_SMP around a block containing a 
> > reference to cpu_llc_shared_map.  Rather than replace the 
> > #ifdef, move cpu_llc_shared_map to be a new cpumask_t field 
> > llc_shared_map in struct cpuinfo_x86 and adjust all 
> > references to cpu_llc_shared_map.
> > 
> 
> I'm not comfortable with a patch this large after we are 
> already at -rc4.  Please send a minimal patch to fix the 
> failure for v3.3, and then a patch on top of that which we can 
> queue up with the rest of the patchset to for v3.4.

I forgot about the v3.3 aspect of the series - yes, you are 
right, doing it like that would be preferred.

It can all be in the same series, we'll sort apart the v3.3 and 
v3.4 bits.

Thanks,

	Ingo
