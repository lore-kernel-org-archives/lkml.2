Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab0D1S1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:27:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756232Ab0D1S1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:27:14 -0400
Date: Wed, 28 Apr 2010 11:26:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, x86@kernel.org,
       clalance@redhat.com, drjones@redhat.com
Subject: Re: [PATCH] Fix NULL pointer for Xen guests
Message-Id: <20100428112658.4cf11292.akpm@linux-foundation.org>
In-Reply-To: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com>
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 11:24:42 -0400
Prarit Bhargava <prarit@redhat.com> wrote:

> Upstream PV guests fail to boot because of a NULL pointer.  It is possible that
> xen guests have irq_desc->chip_data = NULL.
> 
> Test for NULL chip_data pointer before attempting to complete an irq move.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 127b871..eb2789c 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -2545,6 +2545,9 @@ void irq_force_complete_move(int irq)
>  	struct irq_desc *desc = irq_to_desc(irq);
>  	struct irq_cfg *cfg = desc->chip_data;
>  
> +	if (!cfg)
> +		return;
> +
>  	__irq_complete_move(&desc, cfg->vector);
>  }
>  #else

I assume this is needed for 2.6.34?

What about 2.6.33.x and earlier?
