Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0EHIQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 04:16:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34854 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab0EHIQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 04:16:47 -0400
Date: Sat, 8 May 2010 10:16:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       greg@kroah.com, hjanssen@microsoft.com, ksrinivasan@novell.com,
       tglx@linutronix.de, akataria@vmware.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cpu] x86: Clean up the hypervisor layer
Message-ID: <20100508081634.GA23029@elte.hu>
References: <4BE49778.6060800@zytor.com>
 <tip-e08cae4181af9483b04ecfac48f01c8e5a5f27bf@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-e08cae4181af9483b04ecfac48f01c8e5a5f27bf@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for H. Peter Anvin <hpa@zytor.com> wrote:

> Commit-ID:  e08cae4181af9483b04ecfac48f01c8e5a5f27bf
> Gitweb:     http://git.kernel.org/tip/e08cae4181af9483b04ecfac48f01c8e5a5f27bf
> Author:     H. Peter Anvin <hpa@zytor.com>
> AuthorDate: Fri, 7 May 2010 16:57:28 -0700
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Fri, 7 May 2010 17:13:04 -0700
> 
> x86: Clean up the hypervisor layer
> 
> Clean up the hypervisor layer and the hypervisor drivers, using an ops
> structure instead of an enumeration with if statements.
> 
> The identity of the hypervisor, if needed, can be tested by testing
> the pointer value in x86_hyper.
> 
> The MS-HyperV private state is moved into a normal global variable
> (it's per-system state, not per-CPU state).  Being a normal bss
> variable, it will be left at all zero on non-HyperV platforms, and so
> can generally be tested for HyperV-specific features without
> additional qualification.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Acked-by: Greg KH <greg@kroah.com>
> Cc: Hank Janssen <hjanssen@microsoft.com>
> Cc: Alok Kataria <akataria@vmware.com>
> Cc: Ky Srinivasan <ksrinivasan@novell.com>
> LKML-Reference: <4BE49778.6060800@zytor.com>
> ---
>  arch/x86/include/asm/hyperv.h     |    5 ++-
>  arch/x86/include/asm/hypervisor.h |   27 ++++++++++++++++-
>  arch/x86/include/asm/mshyperv.h   |   15 +++++++--
>  arch/x86/include/asm/processor.h  |    7 ----
>  arch/x86/include/asm/vmware.h     |   27 ------------------
>  arch/x86/kernel/cpu/hypervisor.c  |   56 ++++++++++++++++++++++--------------
>  arch/x86/kernel/cpu/mshyperv.c    |   51 ++++++++++++++++------------------
>  arch/x86/kernel/cpu/vmware.c      |   36 +++++++++++++----------
>  8 files changed, 117 insertions(+), 107 deletions(-)

Note, this patch breaks the build of the new vmware baloon driver:

  drivers/misc/vmware_balloon.c:44:24: error: asm/vmware.h: No such file or directory

CONFIG_VMWARE_BALLOON=y

Thanks,

	Ingo
