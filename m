Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2HECvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 22:51:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44094 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab2HECvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 22:51:16 -0400
Date: Sun, 5 Aug 2012 12:50:57 +1000
From: Ben Skeggs <skeggsb@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Nouveau] [PATCH] nouveau: Do not use nva3 engine for 0xaf
 chipset
Message-ID: <20120805025057.GA10386@turiel.redhat.com>
References: <1344060045-784-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344060045-784-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 08:00:45AM +0200, Henrik Rydberg wrote:
> The nva3 copy engine exhibits random memory corruption in at least one
> case, the GeForce 320M (nv50, 0xaf) in the MacBookAir3,1.  This patch
> omits creating the engine for the specific chipset, falling back to
> M2MF, which kills the symptoms.
I've pushed this (with slightly modified commit message) to nouveau git.

I'll get it to Linus' tree in a future -fixes merge.

Thanks,
Ben.

> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi Ben,
> 
> this patch is still needed in 3.6-rc1, so perhaps we should apply it
> after all. I have been running it without problems for a long time
> now.
> 
> Thanks,
> Henrik
> 
>  drivers/gpu/drm/nouveau/nouveau_state.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c b/drivers/gpu/drm/nouveau/nouveau_state.c
> index 1cdfd6e..1866dbb 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_state.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_state.c
> @@ -731,7 +731,6 @@ nouveau_card_init(struct drm_device *dev)
>  			case 0xa3:
>  			case 0xa5:
>  			case 0xa8:
> -			case 0xaf:
>  				nva3_copy_create(dev);
>  				break;
>  			}
> -- 
> 1.7.11.4
> 
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/nouveau
