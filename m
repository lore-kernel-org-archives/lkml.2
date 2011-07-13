Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1GMVof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:44:35 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:61491 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1GMVoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:44:34 -0400
Date: Wed, 13 Jul 2011 16:44:26 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86 intel power: Initialize MSR_IA32_ENERGY_PERF_BIAS
In-reply-to: <20110415101712.GB28007@elte.hu>
Message-id: <alpine.LFD.2.02.1107131640280.9546@x980>
References: <alpine.LFD.2.02.1103301819250.31342@x980>
 <20110414090854.GB9248@elte.hu> <alpine.LFD.2.02.1104150202310.29365@x980>
 <20110415101712.GB28007@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So how about informing users, how about making it non-silent? An informative 
> printk that also mentions the power configuration tool, etc. This solves the 
> concerns i mentioned.

Something like this?

                rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
                if ((epb & 0xF) == 0) {
                        printk_once(KERN_WARN, "x86: updated energy_perf_bias"
                                " to 'normal' from 'performance'\n"
                                "You can view and update epb via utility,"
                                " such as x86_energy_perf_policy(8)\n");
                        epb = (epb & ~0xF) | ENERGY_PERF_BIAS_NORMAL;
                        wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
                }

