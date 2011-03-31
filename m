Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab1CaHCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 03:02:10 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:60411 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab1CaHCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 03:02:08 -0400
Date: Thu, 31 Mar 2011 03:02:00 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/9] x86 idle: remove NOP cpuinfo_x86.hlt_works_ok flag
In-reply-to: <20110331061247.GA24786@elte.hu>
Message-id: <alpine.LFD.2.02.1103310252160.8569@x980>
References: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1301550524.git.len.brown@intel.com>
 <b048802b0285a5ff28e74a4309d833116174904a.1301550524.git.len.brown@intel.com>
 <20110331061247.GA24786@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > hlt_works_ok was X86_32 only, initialized to 1, and never cleared.
> > 
> > On 32-bit kernels, this deletes a line from /proc/cpuinfo: "hlt_bug : no"
> 
> I think you missed the valid usecase where an old CPU with broken halt is 
> booted with the no-hlt boot parameter and does not want to crash in the HLT 
> instruction.
> 
> That "no-hlt" boot parameter does:
> 
>   arch/x86/kernel/cpu/bugs.c:     boot_cpu_data.hlt_works_ok = 0;
> 
> We can restrict compatibility, but *please* lets do it *explicitly*, not under 
> some 'remove unused code' pretense ...
> 
> Could you please list all CPU models that are affected?

"no-hlt" existed only for 32-bit, and there were exactly zero
automatic invocations of it.

"idle=poll" does the same thing -- sans change a line
in /proc/cpuinfo.

Do we really need both?

thanks,
-Len



