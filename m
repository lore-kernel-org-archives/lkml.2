Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab1EaPPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:15:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:48418 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1EaPPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:15:48 -0400
Message-ID: <4DE50617.7090509@linutronix.de>
Date: Tue, 31 May 2011 17:15:35 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Suzuki Poulose <suzuki@in.ibm.com>
CC: linux ppc dev <linuxppc-dev@lists.ozlabs.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Kexec support for PPC440x
References: <4DE345B0.8020505@in.ibm.com>
In-Reply-To: <4DE345B0.8020505@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Suzuki Poulose wrote:
> Index: powerpc/arch/powerpc/kernel/44x_kexec_mapping.S
> ===================================================================
> --- /dev/null
> +++ powerpc/arch/powerpc/kernel/44x_kexec_mapping.S
....

> + *
> + */
> +    bl    nxtins                /* Find our address */
> +nxtins:    mflr    r5                /* Make it accessible */

Please don't mix labels and instructions.

> +    tlbsx    r23,0,r5            /* Find entry we are in */

using tabs instead of spaces would make it look nice. Please also separate 
the arguments of the instruction i.e.
	tlbsx	r23, 0, r5


> Index: powerpc/arch/powerpc/kernel/misc_32.S
> ===================================================================
> --- powerpc.orig/arch/powerpc/kernel/misc_32.S
> +++ powerpc/arch/powerpc/kernel/misc_32.S
> @@ -736,6 +736,28 @@ relocate_new_kernel:
>      mr      r5, r31
>  
>      li    r0, 0
> +#elif defined(CONFIG_44x)  && !defined(CONFIG_47x)
> +
> +    mr    r29, r3
> +    mr    r30, r4
> +    mr    r31, r5
> +
> +#include "44x_kexec_mapping.S"

The way you setup the 1:1 mapping should be close to what you are doing on
kernel entry. Isn't it possible to include the file here and in the entry
code?

Sebastian
