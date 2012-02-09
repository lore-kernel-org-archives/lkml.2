Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab2BIKgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 05:36:42 -0500
Received: from www.linutronix.de ([62.245.132.108]:34862 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672Ab2BIKgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 05:36:41 -0500
Date: Thu, 9 Feb 2012 11:36:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prarit Bhargava <prarit@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use NUMA node cpu mask in irq affinity
In-Reply-To: <1328734113-3608-1-git-send-email-prarit@redhat.com>
Message-ID: <alpine.LFD.2.02.1202091132590.2794@ionos>
References: <1328734113-3608-1-git-send-email-prarit@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Feb 2012, Prarit Bhargava wrote:

Could you please CC the relevant maintainers ?

> The irq affinity files (/proc/irq/.../smp_affinity) contain a mask that is used
> to "pin" an irq to a set of cpus.  On boot this set is currently all cpus.
> This can be incorrect as ACPI SRAT may tell us that a specific device or
> bus is attached to a particular node and it's cpus.
> 
> When setting up the irq affinity we should take into account the NUMA node
> cpu mask by and'ing it into the irq's affinity mask.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> ---
>  kernel/irq/manage.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index a9a9dbe..2fb3469 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -301,6 +301,8 @@ setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
>  	}
>  
>  	cpumask_and(mask, cpu_online_mask, set);
> +	if (desc->irq_data.node != -1)
> +		cpumask_and(mask, mask, cpumask_of_node(desc->irq_data.node));

What prevents mask from becoming empty if mask does not intersect with
the node mask?

Thanks,

	tglx
