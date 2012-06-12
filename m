Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab2FLQos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:44:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51290 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab2FLQoq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:44:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120612162633.GA11077@elgon.mountain>
References: <20120612162633.GA11077@elgon.mountain>
Date: Tue, 12 Jun 2012 09:44:45 -0700
X-Google-Sender-Auth: bf2HDS84f7wcmrm69E6QlfaAglQ
Message-ID: <CAE9FiQWG37f4E+ys2uXzrTSHbmhmF2gx+df0eqfRZ_JnKhCC2Q@mail.gmail.com>
Subject: Re: [patch -next] irq_remap: silence a bogus pr_err()
From: Yinghai Lu <yinghai@kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Alexander Gordeev <agordeev@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 9:26 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> There is an extra semicolon here so the pr_err() message is printed when
> it is not intended.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
> index dafbad0..853902a 100644
> --- a/drivers/iommu/intel_irq_remapping.c
> +++ b/drivers/iommu/intel_irq_remapping.c
> @@ -938,7 +938,7 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
>
>        err = apic->cpu_mask_to_apicid_and(cfg->domain, mask, &dest);
>        if (err) {
> -               if (assign_irq_vector(irq, cfg, data->affinity));
> +               if (assign_irq_vector(irq, cfg, data->affinity))
>                        pr_err("Failed to recover vector for irq %d\n", irq);
>                return err;
>        }

introduced by:

commit ff164324123c0fe181d8de7dadcc7b3fbe25f2cf
Author: Alexander Gordeev <agordeev@redhat.com>
Date:   Thu Jun 7 15:15:59 2012 +0200

    x86/apic: Make cpu_mask_to_apicid() operations return error code
