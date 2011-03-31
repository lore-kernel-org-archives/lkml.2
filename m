Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab1CaGNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:13:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45396 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab1CaGNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:13:07 -0400
Date: Thu, 31 Mar 2011 08:12:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/9] x86 idle: remove NOP cpuinfo_x86.hlt_works_ok flag
Message-ID: <20110331061247.GA24786@elte.hu>
References: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1301550524.git.len.brown@intel.com>
 <b048802b0285a5ff28e74a4309d833116174904a.1301550524.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b048802b0285a5ff28e74a4309d833116174904a.1301550524.git.len.brown@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Len Brown <lenb@kernel.org> wrote:

> From: Len Brown <len.brown@intel.com>
> 
> hlt_works_ok was X86_32 only, initialized to 1, and never cleared.
> 
> On 32-bit kernels, this deletes a line from /proc/cpuinfo: "hlt_bug : no"

I think you missed the valid usecase where an old CPU with broken halt is 
booted with the no-hlt boot parameter and does not want to crash in the HLT 
instruction.

That "no-hlt" boot parameter does:

  arch/x86/kernel/cpu/bugs.c:     boot_cpu_data.hlt_works_ok = 0;

We can restrict compatibility, but *please* lets do it *explicitly*, not under 
some 'remove unused code' pretense ...

Could you please list all CPU models that are affected?

Thanks,

	Ingo
