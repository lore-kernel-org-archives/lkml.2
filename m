Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab1IHXAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:00:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:52828 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757162Ab1IHW75 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 18:59:57 -0400
Subject: Re: [RFC PATCH 03/10] fadump: Register for firmware assisted dump.
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20110713180705.6210.44160.stgit@mars.in.ibm.com>
Date: Thu, 8 Sep 2011 13:34:15 -0500
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Haren Myneni <hbabu@us.ibm.com>, Anton Blanchard <anton@samba.org>,
        Milton Miller <miltonm@bga.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <1D6A3FC8-816D-4257-A50E-60D1FCE7259F@kernel.crashing.org>
References: <20110713180252.6210.34810.stgit@mars.in.ibm.com> <20110713180705.6210.44160.stgit@mars.in.ibm.com>
To: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.1244.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
> index a88bf27..3031ea7 100644
> --- a/arch/powerpc/kernel/setup_64.c
> +++ b/arch/powerpc/kernel/setup_64.c
> @@ -63,6 +63,7 @@
> #include <asm/kexec.h>
> #include <asm/mmu_context.h>
> #include <asm/code-patching.h>
> +#include <asm/fadump.h>
> 
> #include "setup.h"
> 
> @@ -371,6 +372,13 @@ void __init setup_system(void)
> 	rtas_initialize();
> #endif /* CONFIG_PPC_RTAS */
> 
> +#ifdef CONFIG_FA_DUMP
> +	/*
> +	 * Setup Firmware-assisted dump.
> +	 */
> +	setup_fadump();

Is there a reason this has to be done here?  Can it be an initcall or called from platform init code?

> +#endif
> +

- k



