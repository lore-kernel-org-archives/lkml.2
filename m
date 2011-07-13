Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965209Ab1GMLSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 07:18:07 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47031 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965086Ab1GMLSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 07:18:05 -0400
Date: Wed, 13 Jul 2011 07:18:22 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Benjammin Herrenschmidt <benh@kernel.crashing.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>,
        kexec <kexec@lists.infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH v2] powerpc32: Kexec support for PPC440X chipsets
Message-ID: <20110713111822.GE4203@zod.rchland.ibm.com>
References: <20110712064356.28567.48722.stgit@suzukikp.in.ibm.com>
 <BE0C6BFF-E55A-4860-A05C-CA5313012FCC@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BE0C6BFF-E55A-4860-A05C-CA5313012FCC@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 12:28:36AM -0500, Kumar Gala wrote:
>
>On Jul 12, 2011, at 1:44 AM, Suzuki K. Poulose wrote:
>
>> Changes from V1: Uses a tmp mapping in the other address space to setup
>> 		 the 1:1 mapping (suggested by Sebastian Andrzej Siewior).
>> 
>> Note: Should we do the same for kernel entry code for PPC44x ?
>> 
>> This patch adds kexec support for PPC440 based chipsets.This work is based
>> on the KEXEC patches for FSL BookE.
>> 
>> The FSL BookE patch and the code flow could be found at the link below:
>> 
>> 	http://patchwork.ozlabs.org/patch/49359/
>> 
>> Steps:
>> 
>> 1) Invalidate all the TLB entries except the one this code is run from
>> 2) Create a tmp mapping for our code in the other address space and jump to it
>> 3) Invalidate the entry we used
>> 4) Create a 1:1 mapping for 0-2GiB in blocks of 256M
>> 5) Jump to the new 1:1 mapping and invalidate the tmp mapping
>> 
>> I have tested this patches on Ebony, Sequoia boards and Virtex on QEMU.
>> It would be great if somebody could test this on the other boards.
>> 
>> Signed-off-by: 	Suzuki Poulose <suzuki@in.ibm.com>
>> Cc:	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> ---
>> 
>> arch/powerpc/Kconfig             |    2 
>> arch/powerpc/include/asm/kexec.h |    2 
>> arch/powerpc/kernel/misc_32.S    |  170 ++++++++++++++++++++++++++++++++++++++
>> 3 files changed, 172 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> index 423145a6..d04fae0 100644
>> --- a/arch/powerpc/Kconfig
>> +++ b/arch/powerpc/Kconfig
>> @@ -349,7 +349,7 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
>> 
>> config KEXEC
>> 	bool "kexec system call (EXPERIMENTAL)"
>> -	depends on (PPC_BOOK3S || FSL_BOOKE) && EXPERIMENTAL
>> +	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP && !47x)) && EXPERIMENTAL
>
>Is there something special about 47x that its not supported?

It's a different MMU type (again), that is similar to 44x but not exact.
We can't run a single kernel image on both yet, for example.

Also, they aren't widely available so testing on them is difficult.

josh
