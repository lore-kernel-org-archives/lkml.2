Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab2HQRPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:15:01 -0400
Received: from mga06.intel.com ([134.134.136.21]:20036 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753668Ab2HQROx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:14:53 -0400
MIME-Version: 1.0
In-Reply-To: <1344918891-6283-8-git-send-email-keithp@keithp.com>
References: <1344918891-6283-1-git-send-email-keithp@keithp.com>
	<1344918891-6283-8-git-send-email-keithp@keithp.com>
Date: Fri, 17 Aug 2012 18:14:50 +0100
Message-ID: <CAPX-8+-kfzGCZSyGFuWJESEqNoTyzytbxX75=3=-hLP2uAwApw@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 7/7] drm/i915: Merge FDI RX reg writes during training
From: "Lespiau, Damien" <damien.lespiau@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 5:34 AM, Keith Packard <keithp@keithp.com> wrote:
> @@ -2324,6 +2324,8 @@ static void intel_fdi_normal_train(struct drm_crtc *crtc)
>                 temp |= FDI_LINK_TRAIN_NONE | FDI_TX_ENHANCE_FRAME_ENABLE;
>         }
>         I915_WRITE(reg, temp);
> +       POSTING_READ(reg);
> +       udelay(100);

The docs don't mention a delay between writing the TX and RX training
patterns, the POSTING_READ() seems like a good idea.

>         reg = FDI_RX_CTL(pipe);
>         temp = I915_READ(reg);
> @@ -2334,16 +2336,15 @@ static void intel_fdi_normal_train(struct drm_crtc *crtc)
>                 temp &= ~FDI_LINK_TRAIN_NONE;
>                 temp |= FDI_LINK_TRAIN_NONE;
>         }
> +       /* IVB wants error correction enabled */
> +       if (IS_IVYBRIDGE(dev))
> +               temp |= FDI_FS_ERRC_ENABLE | FDI_FE_ERRC_ENABLE;
> +
>         I915_WRITE(reg, temp | FDI_RX_ENHANCE_FRAME_ENABLE);
>
>         /* wait one idle pattern time */
>         POSTING_READ(reg);
>         udelay(1000);
> -
> -       /* IVB wants error correction enabled */
> -       if (IS_IVYBRIDGE(dev))
> -               I915_WRITE(reg, I915_READ(reg) | FDI_FS_ERRC_ENABLE |
> -                          FDI_FE_ERRC_ENABLE);
>  }
>
>  static void cpt_phase_pointer_enable(struct drm_device *dev, int pipe)

Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>

-- 
Damien
