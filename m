Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab0CQWSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:18:35 -0400
Received: from smtp-out.google.com ([74.125.121.35]:7011 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab0CQWSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:18:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=WFK2f4ty3xAg2KPBFXwO0aZNlsxQwOT01VgN8rYA+6k/TG1VA4wnTyX5u1G4/+6ec
	R7Vf3dFY06UEpbsqoGniA==
MIME-Version: 1.0
In-Reply-To: <20100317173500.31124.53755.stgit@bob.kio>
References: <20100317173329.31124.69795.stgit@bob.kio>
	 <20100317173500.31124.53755.stgit@bob.kio>
Date: Wed, 17 Mar 2010 15:18:27 -0700
Message-ID: <3055132f1003171518o46c4712bk5089a7bab8574019@mail.gmail.com>
Subject: Re: [PATCH 1/3] hpet: convert to PNP driver
From: Venkatesh Pallipadi <venki@google.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-acpi@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 10:35 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>
> PNPACPI already parses _CRS, and does a more complete job than we did here,
> so let's just take advantage of that.
>

Patch looks good.
One comment is that we now have a dependency on CONFIG_PNP. That
probably needs to be added in drivers/char/Kconfig. But, that also
means we may fail for users who do not have PNP in their config today.
May be just select PNP when HPET is selected?

> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---
>
>  drivers/char/hpet.c |  103 +++++++++++++--------------------------------------
>  1 files changed, 27 insertions(+), 76 deletions(-)
>
>
>
> -       if (!data.hd_address || !data.hd_nirqs) {
> -               printk("%s: no address or irqs in _CRS\n", __func__);
> -               return -ENODEV;
> -       }
> +       data.hd_address = ioremap(mem->start, resource_size(mem));
>
>        return hpet_alloc(&data);
>  }

Not a problem with this patch. But, don't we have a problem of rogue
ioremap when hpet_alloc() fails here?

Thanks,
Venki
