Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab1IMI2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 04:28:00 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:33132 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab1IMI16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 04:27:58 -0400
In-Reply-To: <OF29249FB5.153CCB29-ONC1257909.00499475-C1257909.00499954@LocalDomain>
References: <OF29249FB5.153CCB29-ONC1257909.00499475-C1257909.00499954@LocalDomain>
Subject: Re: [PATCH 37/62] infiniband: irq: Remove IRQF_DISABLED
X-KeepSent: 5F6785FA:2466AF15-C125790A:002E2A52;
 type=4; name=$KeepSent
To: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org,
        Christoph Raisch <raisch@de.ibm.com>
X-Mailer: Lotus Notes Release 8.0.2 HF623 January 16, 2009
Message-ID: <OF5F6785FA.2466AF15-ONC125790A.002E2A52-C125790A.002E8113@de.ibm.com>
From: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Date: Tue, 13 Sep 2011 10:27:16 +0200
X-MIMETrack: Serialize by Router on D06ML030/06/M/IBM(Release 8.5.2FP1 ZX852FP1HF11|June
 14, 2011) at 13/09/2011 10:27:17
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks fine to me.
Thx
Nam

> From: Yong Zhang <yong.zhang0@gmail.com>
> To: linux-kernel@vger.kernel.org
> Cc: tglx@linutronix.de, mingo@elte.hu, Hoang-Nam Nguyen/Germany/
> IBM@IBMDE, Christoph Raisch/Germany/IBM@IBMDE, Roland Dreier
> <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal
> Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
> Date: 09/07/2011 10:22 AM
> Subject: [PATCH 37/62] infiniband: irq: Remove IRQF_DISABLED
>
> This flag is a NOOP and can be removed now.
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---
>  drivers/infiniband/hw/ehca/ehca_eq.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ehca/ehca_eq.c b/drivers/
> infiniband/hw/ehca/ehca_eq.c
> index d9b1bb4..818d721 100644
> --- a/drivers/infiniband/hw/ehca/ehca_eq.c
> +++ b/drivers/infiniband/hw/ehca/ehca_eq.c
> @@ -125,7 +125,7 @@ int ehca_create_eq(struct ehca_shca *shca,
>        tasklet_init(&eq->interrupt_task, ehca_tasklet_eq, (long)shca);
>
>        ret = ibmebus_request_irq(eq->ist, ehca_interrupt_eq,
> -                 IRQF_DISABLED, "ehca_eq",
> +                 0, "ehca_eq",
>                   (void *)shca);
>        if (ret < 0)
>           ehca_err(ib_dev, "Can't map interrupt handler.");
> @@ -133,7 +133,7 @@ int ehca_create_eq(struct ehca_shca *shca,
>        tasklet_init(&eq->interrupt_task, ehca_tasklet_neq, (long)shca);
>
>        ret = ibmebus_request_irq(eq->ist, ehca_interrupt_neq,
> -                 IRQF_DISABLED, "ehca_neq",
> +                 0, "ehca_neq",
>                   (void *)shca);
>        if (ret < 0)
>           ehca_err(ib_dev, "Can't map interrupt handler.");
> --
> 1.7.4.1
>

