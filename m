Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab2GEGk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 02:40:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59690 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab2GEGk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 02:40:57 -0400
Date: Thu, 5 Jul 2012 16:40:49 +1000
From: Ben Skeggs <skeggsb@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [REGRESSION] nouveau: Memory corruption using nva3 engine for
 0xaf
Message-ID: <20120705064049.GA8693@nisroch.bne.redhat.com>
References: <1341469873-1582-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341469873-1582-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 08:31:13AM +0200, Henrik Rydberg wrote:
> Hi Ben, Dave,
Hey Henrik,

> 
> Since 3.5-rc0, I have been experiencing occasional screen corruption
> on my MacBookAir3,1, using a GeForce 320M (nv50, 0xaf). The X driver
> version is xf86-video-nouvea-1.0.1-1 (arch).
> 
> I do not know what the root problem is, but I have been able to
> isolate the symptoms to the usage of nva3_copy.c. The patch below is
> the least intrusive way I could find which kills the symptoms.
> 
> Hopefully this will sched some light on the true problem, such that a
> fix can be found for 3.5.
Thanks for tracking down the source of this corruption.  I don't have
any such hardware, so until someone can figure it out, I think we
should apply this patch.

Cheers,
Ben.

> 
> Thanks,
> Henrik
> 
> The nva3 copy engine exhibits random memory corruption in at least one
> case, the GeForce 320M (nv50, 0xaf) in the MacBookAir3,1.  This patch
> omits creating the engine for the specific chipset, falling back to
> M2MF, which kills the symptoms.
> ---
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

>  drivers/gpu/drm/nouveau/nouveau_state.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c b/drivers/gpu/drm/nouveau/nouveau_state.c
> index 19706f0..b466937 100644
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
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
