Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab0CRT0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 15:26:06 -0400
Received: from smtp-out.google.com ([74.125.121.35]:23239 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab0CRTZn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 15:25:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=drm5OW0UJkVjSs68TgRgQS0ggobO3Jh8T0vJ7YX9w9lugnlYLu5z47bQ/mDwG5/VW
	AtxitTOPNeRFbkCgDKnUA==
MIME-Version: 1.0
In-Reply-To: <20100318175940.15143.53027.stgit@bob.kio>
References: <20100318175852.15143.2124.stgit@bob.kio>
	 <20100318175940.15143.53027.stgit@bob.kio>
Date: Thu, 18 Mar 2010 12:25:39 -0700
Message-ID: <3055132f1003181225x797cb955oeed07c50b1652952@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] hpet: clean up io mapping when hpet_alloc() fails
From: Venkatesh Pallipadi <venki@google.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, Vojtech Pavlik <vojtech@suse.cz>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Venkatesh Pallipadi <venki@google.com>

On Thu, Mar 18, 2010 at 10:59 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>
> When hpet_alloc() fails, we should iounmap() the timer so we don't leak
> the mapping.
>
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---
>
>  drivers/char/hpet.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>
>
> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> index d132fef..8961985 100644
> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -904,7 +904,7 @@ static int hpet_pnp_add(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
>  {
>        struct hpet_data data;
>        struct resource *mem, *irq;
> -       int i;
> +       int i, ret;
>
>        memset(&data, 0, sizeof(data));
>
> @@ -924,7 +924,11 @@ static int hpet_pnp_add(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
>        data.hd_phys_address = mem->start;
>        data.hd_address = ioremap(mem->start, resource_size(mem));
>
> -       return hpet_alloc(&data);
> +       ret = hpet_alloc(&data);
> +       if (ret)
> +               iounmap(data.hd_address);
> +
> +       return ret;
>  }
>
>  static void hpet_pnp_remove(struct pnp_dev *dev)
>
>
