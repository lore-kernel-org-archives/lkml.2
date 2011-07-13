Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab1GMF3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 01:29:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:53252 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab1GMF3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 01:29:46 -0400
Subject: Re: [PATCH v2] powerpc32: Kexec support for PPC440X chipsets
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20110712064356.28567.48722.stgit@suzukikp.in.ibm.com>
Date: Wed, 13 Jul 2011 00:28:36 -0500
Cc: Benjammin Herrenschmidt <benh@kernel.crashing.org>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>,
        kexec <kexec@lists.infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <BE0C6BFF-E55A-4860-A05C-CA5313012FCC@kernel.crashing.org>
References: <20110712064356.28567.48722.stgit@suzukikp.in.ibm.com>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 12, 2011, at 1:44 AM, Suzuki K. Poulose wrote:

> Changes from V1: Uses a tmp mapping in the other address space to setup
> 		 the 1:1 mapping (suggested by Sebastian Andrzej Siewior).
> 
> Note: Should we do the same for kernel entry code for PPC44x ?
> 
> This patch adds kexec support for PPC440 based chipsets.This work is based
> on the KEXEC patches for FSL BookE.
> 
> The FSL BookE patch and the code flow could be found at the link below:
> 
> 	http://patchwork.ozlabs.org/patch/49359/
> 
> Steps:
> 
> 1) Invalidate all the TLB entries except the one this code is run from
> 2) Create a tmp mapping for our code in the other address space and jump to it
> 3) Invalidate the entry we used
> 4) Create a 1:1 mapping for 0-2GiB in blocks of 256M
> 5) Jump to the new 1:1 mapping and invalidate the tmp mapping
> 
> I have tested this patches on Ebony, Sequoia boards and Virtex on QEMU.
> It would be great if somebody could test this on the other boards.
> 
> Signed-off-by: 	Suzuki Poulose <suzuki@in.ibm.com>
> Cc:	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> 
> arch/powerpc/Kconfig             |    2 
> arch/powerpc/include/asm/kexec.h |    2 
> arch/powerpc/kernel/misc_32.S    |  170 ++++++++++++++++++++++++++++++++++++++
> 3 files changed, 172 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 423145a6..d04fae0 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -349,7 +349,7 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
> 
> config KEXEC
> 	bool "kexec system call (EXPERIMENTAL)"
> -	depends on (PPC_BOOK3S || FSL_BOOKE) && EXPERIMENTAL
> +	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP && !47x)) && EXPERIMENTAL

Is there something special about 47x that its not supported?

> 	help
> 	  kexec is a system call that implements the ability to shutdown your
> 	  current kernel, and to start another kernel.  It is like a reboot

- k