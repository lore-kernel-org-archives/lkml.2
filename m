Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab1GCOjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 10:39:23 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:64920 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab1GCOjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 10:39:21 -0400
Date: Sun, 3 Jul 2011 16:39:13 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Paul Menzel <paulepanter@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] nouveau: Do not leak in nv20_graph_create
Message-ID: <20110703143913.GA3217@joi.lan>
References: <alpine.LNX.2.00.1107031224030.16316@swampdragon.chaosbits.net>
 <1309690311.20270.27.camel@mattotaupa>
 <alpine.LNX.2.00.1107031315520.18279@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1107031321150.18279@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107031321150.18279@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 03, 2011 at 01:21:55PM +0200, Jesper Juhl wrote:
> From: Jesper Juhl <jj@chaosbits.net>
> Subject: [PATCH] nouveau: Do not leak in nv20_graph_create
> 
> If we return due to an unknown chipset in drivers/gpu/drm/nouveau/nv20_graph.c:nv20_graph_create() we'll leak the memory allocated to 'pgraph'.
> 
> This patch should fix the leak and it also disambiguates the "PGRAPH:
> unknown chipset\n" error message - it's nice to be able to tell which
> branch created the error which is impossible if the error messages are
> 100% identical.

There's no need to change these strings. Nouveau prints chipset id earlier.
For patch with only kfrees:
Reviewed-by: Marcin Slusarz <marcin.slusarz@gmail.com>

> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/gpu/drm/nouveau/nv20_graph.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nv20_graph.c b/drivers/gpu/drm/nouveau/nv20_graph.c
> index affc7d7..53cbe84 100644
> --- a/drivers/gpu/drm/nouveau/nv20_graph.c
> +++ b/drivers/gpu/drm/nouveau/nv20_graph.c
> @@ -752,6 +752,7 @@ nv20_graph_create(struct drm_device *dev)
>  			pgraph->grctx_user = 0x0000;
>  			break;
>  		default:
> +			kfree(pgraph);
>  			NV_ERROR(dev, "PGRAPH: unknown chipset\n");
>  			return 0;
>  		}
> @@ -773,7 +774,8 @@ nv20_graph_create(struct drm_device *dev)
>  			pgraph->grctx_size = NV35_36_GRCTX_SIZE;
>  			break;
>  		default:
> -			NV_ERROR(dev, "PGRAPH: unknown chipset\n");
> +			kfree(pgraph);
> +			NV_ERROR(dev, "PGRAPH: chipset unknown.\n");
>  			return 0;
>  		}
>  	}
> -- 
