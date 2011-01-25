Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab1AYPUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 10:20:32 -0500
Received: from www.tglx.de ([62.245.132.106]:59591 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab1AYPUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 10:20:31 -0500
Date: Tue, 25 Jan 2011 16:20:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/platform: add a wallclock_init func to x86_platforms
 ops
In-Reply-To: <20110125142613.9886.69516.stgit@bob.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1101251618210.31804@localhost6.localdomain6>
References: <20110125142613.9886.69516.stgit@bob.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011, Alan Cox wrote:

> From: Feng Tang <feng.tang@intel.com>
> 
> Some wall clock devices use MMIO based HW register, this new function will
> give them a chance to do some initialization work before their get/set_time
> service get called.
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  arch/x86/include/asm/x86_init.h |    2 ++
>  arch/x86/kernel/setup.c         |    2 ++
>  arch/x86/kernel/x86_init.c      |    2 ++
>  3 files changed, 6 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
> index 64642ad..f7fa2e7 100644
> --- a/arch/x86/include/asm/x86_init.h
> +++ b/arch/x86/include/asm/x86_init.h
> @@ -138,6 +138,7 @@ struct x86_cpuinit_ops {
>  /**
>   * struct x86_platform_ops - platform specific runtime functions
>   * @calibrate_tsc:		calibrate TSC
> + * @wallclock_init:		init the wallclock device

That's a one time called init function, so it should go into
x86_init_ops.

Thanks,

	tglx
