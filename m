Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab1IUUVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:21:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49724 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1IUUVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:21:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=r9zl7RoO1lcT2qHyX0FkxXVZ1VMmMHna4HeyS8C5rCtWoEnwTYIlOVZoKWdaRy/TV
	yxUbH8UsCeQLzpsAZnBow==
MIME-Version: 1.0
In-Reply-To: <1316597339-29861-44-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com> <1316597339-29861-44-git-send-email-yong.zhang0@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 21 Sep 2011 14:20:46 -0600
Message-ID: <CAErSpo7VR8+AGgWABb2c0uU_bgcmg43dxui41JFzmCQPvC7bGg@mail.gmail.com>
Subject: Re: [PATCH 43/57] PNP: irq: Remove IRQF_DISABLED
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Adam Belay <abelay@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 3:28 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
> We run all interrupt handlers with interrupts disabled
> and we even check and yell when an interrupt handler
> returns with interrupts enabled (see commit [b738a50a:
> genirq: Warn when handler enables interrupts]).
>
> So now this flag is a NOOP and can be removed.
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pnp/resource.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
> index b0ecacb..3669821 100644
> --- a/drivers/pnp/resource.c
> +++ b/drivers/pnp/resource.c
> @@ -385,7 +385,7 @@ int pnp_check_irq(struct pnp_dev *dev, struct resource *res)
>         * device is active because it itself may be in use */
>        if (!dev->active) {
>                if (request_irq(*irq, pnp_test_handler,
> -                               IRQF_DISABLED | IRQF_PROBE_SHARED, "pnp", NULL))
> +                               IRQF_PROBE_SHARED, "pnp", NULL))
>                        return 0;
>                free_irq(*irq, NULL);
>        }
> --
> 1.7.4.1
>
>
