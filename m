Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935314Ab2JXRYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:24:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:50610 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932816Ab2JXRYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:24:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,640,1344236400"; 
   d="scan'208";a="159921102"
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Zheng <zheng.z.yan@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Subject: Re: [bug] perf_event_intel_uncore.c build warnings on allnoconfig
References: <20121024072901.GA25890@gmail.com>
Date: Wed, 24 Oct 2012 10:24:41 -0700
In-Reply-To: <20121024072901.GA25890@gmail.com> (Ingo Molnar's message of
	"Wed, 24 Oct 2012 09:29:01 +0200")
Message-ID: <m2y5ivrdeu.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> writes:

> FYI, on a 'make allnoconfig' x86_64 kernel I get a stream of 
> warnings:
>
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function ‘snbep_uncore_pci_disable_box’:
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c:124:9: warning: ‘config’ is used uninitialized in this function [-Wuninitialized]
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function ‘snbep_uncore_pci_enable_box’:
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c:135:9: warning: ‘config’ is used uninitialized in this function [-Wuninitialized]
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function ‘snbep_uncore_pci_read_counter’:
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c:164:2: warning: ‘count’ is used uninitialized in this function [-Wuninitialized]
>
> Please fix this - if pci_read_config_dword() returns an error it 
> should be handled - that will fix these warnings as well.

Can it even return an error on x86? I don't know of any existing
mechanism for this, short of a machine check.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
