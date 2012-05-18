Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544Ab2ERIOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:14:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44355 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab2ERIOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:14:22 -0400
Date: Fri, 18 May 2012 10:14:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vlad Zolotarov <vlad@scalemp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: Re: [PATCH v2 2/2] x86: Added read_mostly declaration/definition to
 vars from smp.h
Message-ID: <20120518081416.GA20872@gmail.com>
References: <201205151831.57871.vlad@scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205151831.57871.vlad@scalemp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vlad Zolotarov <vlad@scalemp.com> wrote:

> Added a "read-mostly" qualifier to the following variables in smp.h:
>  - cpu_sibling_map
>  - cpu_core_map
>  - cpu_llc_shared_map
>  - cpu_llc_id
>  - cpu_number
>  - x86_cpu_to_apicid
>  - x86_bios_cpu_apicid
>  - x86_cpu_to_logical_apicid
> 
> As long as all the variables above are only written during the initialization,
> this change is meant to prevent the false sharing and improve the
> performance on large multiprocessor systems.
> 
> Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
> Signed-off-by: Shai Fultheim <shai@scalemp.com>
> ---
>  arch/x86/include/asm/apic.h    |    2 +-
>  arch/x86/include/asm/smp.h     |   16 ++++++++--------
>  arch/x86/kernel/apic/apic.c    |    6 +++---
>  arch/x86/kernel/setup_percpu.c |    2 +-
>  arch/x86/kernel/smpboot.c      |    8 ++++----
>  5 files changed, 17 insertions(+), 17 deletions(-)


This does not build on !SMP kernels that has APIC enabled.

Thanks,

	Ingo
