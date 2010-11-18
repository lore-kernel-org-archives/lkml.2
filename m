Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab0KRMH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:07:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:42596 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab0KRMH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:07:28 -0500
Subject: Re: [PATCH 3/4] perf-events: Add support for supplementary event
 registers v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1290077254-12165-4-git-send-email-andi@firstfloor.org>
References: <1290077254-12165-1-git-send-email-andi@firstfloor.org>
	 <1290077254-12165-4-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 18 Nov 2010 13:07:36 +0100
Message-ID: <1290082056.2109.1406.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 11:47 +0100, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Intel Nehalem/Westmere have a special OFFCORE_RESPONSE event
> that can be used to monitor any offcore accesses from a core.
> This is a very useful event for various tunings, and it's
> also needed to implement the generic LLC-* events correctly.
> 
> Unfortunately this event requires programming a mask in a separate
> register. And worse this separate register is per core, not per
> CPU thread.
> 
> This patch adds:
> - Teaches perf_events that OFFCORE_RESPONSE needs extra parameters.
> The extra parameters are passed by user space in the unused upper
> 32bits of the config word.
> - Add support to the Intel perf_event core to schedule per
> core resources. This adds fairly generic infrastructure that
> can be also used for other per core resources.
> The basic code has is patterned after the similar AMD northbridge
> constraints code.
> 
> Thanks to Stephane Eranian who pointed out some problems
> in the original version and suggested improvements.

WARNING: please, no space before tabs
#59: FILE: arch/x86/kernel/cpu/perf_event.c:136:
+^Iint ^I^I^I^Ipercore_used; /* Used by this CPU? */$

WARNING: please, no space before tabs
#80: FILE: arch/x86/kernel/cpu/perf_event.c:198:
+^Iu64 ^I^I^Iconfig_mask;$

WARNING: please, no space before tabs
#81: FILE: arch/x86/kernel/cpu/perf_event.c:199:
+^Iu64 ^I^I^Ivalid_mask;$

WARNING: please, no space before tabs
#85: FILE: arch/x86/kernel/cpu/perf_event.c:203:
+^I.event = (e),    ^I\$

WARNING: please, no space before tabs
#86: FILE: arch/x86/kernel/cpu/perf_event.c:204:
+^I.msr = (ms),^I     ^I\$

WARNING: please, no space before tabs
#87: FILE: arch/x86/kernel/cpu/perf_event.c:205:
+^I.config_mask = (m),  ^I\$

WARNING: please, no space before tabs
#177: FILE: arch/x86/kernel/cpu/perf_event_intel.c:12:
+^Iint ^I^Iref;^I^I/* reference count */$

WARNING: please, no space before tabs
#179: FILE: arch/x86/kernel/cpu/perf_event_intel.c:14:
+^Iu64 ^I^Iextra_config;^I/* extra MSR config */$

WARNING: please, no space before tabs
#183: FILE: arch/x86/kernel/cpu/perf_event_intel.c:18:
+^Iraw_spinlock_t ^I^Ilock;^I^I/* protect structure */$

WARNING: please, no space before tabs
#184: FILE: arch/x86/kernel/cpu/perf_event_intel.c:19:
+^Istruct er_account ^Iregs[MAX_EXTRA_REGS];$

WARNING: please use device_initcall() instead of __initcall()
#408: FILE: arch/x86/kernel/cpu/perf_event_intel.c:1108:
+__initcall(init_intel_percore);


Fixed those up, please be more careful next time.
