Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab2JBPIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:08:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59874 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2JBPIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:08:48 -0400
MIME-Version: 1.0
In-Reply-To: <20121002122036.GN1162@florz.florz.dyndns.org>
References: <20121002122036.GN1162@florz.florz.dyndns.org>
Date: Tue, 2 Oct 2012 11:08:46 -0400
Message-ID: <CADnq5_MSv+8Y-n4QN5GXGbBJ64KfwsivarE8dEfihT939TYKBg@mail.gmail.com>
Subject: Re: [PATCH] drm/savage: re-add busmaster enable, regression fix
From: Alex Deucher <alexdeucher@gmail.com>
To: Florian Zumbiehl <florz@florz.de>
Cc: airlied@redhat.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 8:20 AM, Florian Zumbiehl <florz@florz.de> wrote:
> 466e69b8b03b8c1987367912782bc12988ad8794 dropped busmaster enable from the
> global drm code and moved it to the individual drivers, but missed the savage
> driver. So, this re-adds busmaster enable to the savage driver, fixing the
> regression.
>
> Signed-off-by: Florian Zumbiehl <florz@florz.de>

Reviewed-by: Alex Deucher <alexdeucher@gmail.com>

>
> diff --git a/drivers/gpu/drm/savage/savage_bci.c b/drivers/gpu/drm/savage/savage_bci.c
> index 6eb507a..7d3f0f0 100644
> --- a/drivers/gpu/drm/savage/savage_bci.c
> +++ b/drivers/gpu/drm/savage/savage_bci.c
> @@ -547,6 +547,8 @@ int savage_driver_load(struct drm_device *dev, unsigned long chipset)
>
>         dev_priv->chipset = (enum savage_family)chipset;
>
> +       pci_set_master(dev->pdev);
> +
>         return 0;
>  }
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
