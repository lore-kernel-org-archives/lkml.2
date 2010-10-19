Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab0JSSih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:38:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:52572 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755881Ab0JSSig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:38:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,351,1283756400"; 
   d="scan'208";a="668887385"
Message-ID: <4CBDE5AB.4040401@linux.intel.com>
Date: Tue, 19 Oct 2010 11:38:35 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
CC: peterz@infradead.org, lenb@kernel.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com,
        linux-kernel@vger.kernel.org, g.trinabh@gmail.com
Subject: Re: [RFC V1] cpuidle: add idle routine registration and cleanup pm_idle
 pointer
References: <20101019183522.17992.86937.stgit@tringupt.in.ibm.com>
In-Reply-To: <20101019183522.17992.86937.stgit@tringupt.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/19/2010 11:36 AM, Trinabh Gupta wrote:
> The core of the kernel's idle routine on x86 presently depends on an
> exported pm_idle function pointer that is unmanaged and causing
> hazard to various subsystems when they save and restore it.
> The first problem is that this exported pointer can be modified/flipped
> by any subsystem. There is no tracking or notification mechanism.
> Secondly and more importantly, various subsystems save the value of
> this pointer, flip it and later restore to the saved value. There is
> no guarantee that the saved value is still valid. The problem has
> been discussed in [2,3] and Peter Zijlstra suggested removing pm_idle
> and implementing a list based registration [1].
>
> This patch is an initial RFC implementation for x86 architecture
> only. This framework can be generalised for other archs and also
> include the current cpuidle framework for managing multiple idle
> routines.
>
> Tests done with the patch:
> ------------------------
> 1. Build (on 2.6.36-rc7) and booted on x86 with C1E as deepest idle
>     state and current_idle was selected to be mwait_idle.
>
> 2. Build (on 2.5.36-rc8) and booted on x86 (Nehalem) with ACPI C3 as
>     deepest sleep state.  The current_idle was selected to be
>     cpuidle_idle_call which is the cpuidle subsystem that will further
>     select idle routines from {C1,C2,C3}.
>
> Future implementation will try to eliminate this hirearchy and have
> a single registration and menu/idle cpuidle governor for selection
> of idle routine.


looks like you're duplicating the cpuidle subsystem

how about biting the bullet and just always and only use the cpuidle 
subsystem for all idle on x86 ?

