Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1CUFVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 01:21:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38505 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab1CUFU7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 01:20:59 -0400
From: "Janorkar, Mayuresh" <mayur@ti.com>
To: Carl Vanderlip <carlv@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
CC: Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 21 Mar 2011 10:50:47 +0530
Subject: RE: [PATCH 13/20] video: msm: Debugging for send_blit
Thread-Topic: [PATCH 13/20] video: msm: Debugging for send_blit
Thread-Index: AcvlvStqQSujE+7mRymDr+8NCM6W9wBymODw
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB033D22EB7A@dbde02.ent.ti.com>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
 <1300485510-27439-1-git-send-email-carlv@codeaurora.org>
In-Reply-To: <1300485510-27439-1-git-send-email-carlv@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-
> owner@vger.kernel.org] On Behalf Of Carl Vanderlip
> Sent: Saturday, March 19, 2011 3:29 AM
> To: David Brown; Daniel Walker; Bryan Huntsman
> Cc: Brian Swetland; Dima Zavin; Rebecca Schultz Zavin; Colin Cross; linux-
> fbdev@vger.kernel.org; Carl Vanderlip; linux-arm-
> kernel@lists.infradead.org; linux-arm-msm@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH 13/20] video: msm: Debugging for send_blit
> 
> Allows for mdp_writel_dbg to be redefined as needed to debug blits.
> 
> Authors:
> Dima Zavin <dima@android.com>
> Rebecca Schultz Zavin <rebecca@android.com>
> Colin Cross <ccross@android.com>
> 
> Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
> ---
>  drivers/video/msm/mdp_hw.h  |    2 +-
>  drivers/video/msm/mdp_ppp.c |   61 ++++++++++++++++++++++----------------
> ----
>  2 files changed, 33 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/video/msm/mdp_hw.h b/drivers/video/msm/mdp_hw.h
> index acb48f5..fdf9e5e 100644
> --- a/drivers/video/msm/mdp_hw.h
> +++ b/drivers/video/msm/mdp_hw.h
> @@ -87,7 +87,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct
> mdp_blit_req *req,
>  #define MDP_DISPLAY0_ADDR                (0x00054)
>  #define MDP_DISPLAY1_ADDR                (0x00058)
>  #define MDP_EBI2_PORTMAP_MODE            (0x0005c)
> -#define MDP_MODE                         (0x00060)
> +#define MDP_PPP_CMD_MODE                 (0x00060)
>  #define MDP_TV_OUT_STATUS                (0x00064)
>  #define MDP_HW_VERSION                   (0x00070)
>  #define MDP_SW_RESET                     (0x00074)
> diff --git a/drivers/video/msm/mdp_ppp.c b/drivers/video/msm/mdp_ppp.c
> index 3d190b9..290c29a 100644
> --- a/drivers/video/msm/mdp_ppp.c
> +++ b/drivers/video/msm/mdp_ppp.c
> @@ -331,45 +331,48 @@ static void get_chroma_addr(struct mdp_img *img,
> struct mdp_rect *rect,
>  	}
>  }
> 
> +#define mdp_writel_dbg(mdp, val, reg) mdp_writel((mdp), (val), (reg))
> +
>  static int send_blit(const struct mdp_info *mdp, struct mdp_blit_req
> *req,
>  		     struct ppp_regs *regs, struct file *src_file,
>  		     struct file *dst_file)
>  {
> -	mdp_writel(mdp, 1, 0x060);
> -	mdp_writel(mdp, regs->src_rect, PPP_ADDR_SRC_ROI);
> -	mdp_writel(mdp, regs->src0, PPP_ADDR_SRC0);
> -	mdp_writel(mdp, regs->src1, PPP_ADDR_SRC1);
> -	mdp_writel(mdp, regs->src_ystride, PPP_ADDR_SRC_YSTRIDE);
> -	mdp_writel(mdp, regs->src_cfg, PPP_ADDR_SRC_CFG);
> -	mdp_writel(mdp, regs->src_pack, PPP_ADDR_SRC_PACK_PATTERN);
> -
> -	mdp_writel(mdp, regs->op, PPP_ADDR_OPERATION);
> -	mdp_writel(mdp, regs->phasex_init, PPP_ADDR_PHASEX_INIT);
> -	mdp_writel(mdp, regs->phasey_init, PPP_ADDR_PHASEY_INIT);
> -	mdp_writel(mdp, regs->phasex_step, PPP_ADDR_PHASEX_STEP);
> -	mdp_writel(mdp, regs->phasey_step, PPP_ADDR_PHASEY_STEP);
> -
> -	mdp_writel(mdp, (req->alpha << 24) | (req->transp_mask & 0xffffff),
> +#if 0
> +	mdp_writel_dbg(mdp, 1, MDP_PPP_CMD_MODE);
> +#endif
Unused code? You can add a comment explaining why is this not being used couurently.

> +	mdp_writel_dbg(mdp, regs->src_rect, PPP_ADDR_SRC_ROI);
> +	mdp_writel_dbg(mdp, regs->src0, PPP_ADDR_SRC0);
> +	mdp_writel_dbg(mdp, regs->src1, PPP_ADDR_SRC1);
> +	mdp_writel_dbg(mdp, regs->src_ystride, PPP_ADDR_SRC_YSTRIDE);
> +	mdp_writel_dbg(mdp, regs->src_cfg, PPP_ADDR_SRC_CFG);
> +	mdp_writel_dbg(mdp, regs->src_pack, PPP_ADDR_SRC_PACK_PATTERN);
> +
> +	mdp_writel_dbg(mdp, regs->op, PPP_ADDR_OPERATION);
> +	mdp_writel_dbg(mdp, regs->phasex_init, PPP_ADDR_PHASEX_INIT);
> +	mdp_writel_dbg(mdp, regs->phasey_init, PPP_ADDR_PHASEY_INIT);
> +	mdp_writel_dbg(mdp, regs->phasex_step, PPP_ADDR_PHASEX_STEP);
> +	mdp_writel_dbg(mdp, regs->phasey_step, PPP_ADDR_PHASEY_STEP);
> +
> +	mdp_writel_dbg(mdp, regs->edge, PPP_ADDR_EDGE);
> +	mdp_writel_dbg(mdp, (req->alpha << 24) | (req->transp_mask &
> 0xffffff),
>  	       PPP_ADDR_ALPHA_TRANSP);
> 
> -	mdp_writel(mdp, regs->dst_cfg, PPP_ADDR_DST_CFG);
> -	mdp_writel(mdp, regs->dst_pack, PPP_ADDR_DST_PACK_PATTERN);
> -	mdp_writel(mdp, regs->dst_rect, PPP_ADDR_DST_ROI);
> -	mdp_writel(mdp, regs->dst0, PPP_ADDR_DST0);
> -	mdp_writel(mdp, regs->dst1, PPP_ADDR_DST1);
> -	mdp_writel(mdp, regs->dst_ystride, PPP_ADDR_DST_YSTRIDE);
> +	mdp_writel_dbg(mdp, regs->dst_cfg, PPP_ADDR_DST_CFG);
> +	mdp_writel_dbg(mdp, regs->dst_pack, PPP_ADDR_DST_PACK_PATTERN);
> +	mdp_writel_dbg(mdp, regs->dst_rect, PPP_ADDR_DST_ROI);
> +	mdp_writel_dbg(mdp, regs->dst0, PPP_ADDR_DST0);
> +	mdp_writel_dbg(mdp, regs->dst1, PPP_ADDR_DST1);
> +	mdp_writel_dbg(mdp, regs->dst_ystride, PPP_ADDR_DST_YSTRIDE);
> 
> -	mdp_writel(mdp, regs->edge, PPP_ADDR_EDGE);
>  	if (regs->op & PPP_OP_BLEND_ON) {
> -		mdp_writel(mdp, regs->dst0, PPP_ADDR_BG0);
> -		mdp_writel(mdp, regs->dst1, PPP_ADDR_BG1);
> -		mdp_writel(mdp, regs->dst_ystride, PPP_ADDR_BG_YSTRIDE);
> -		mdp_writel(mdp, src_img_cfg[req->dst.format],
> PPP_ADDR_BG_CFG);
> -		mdp_writel(mdp, pack_pattern[req->dst.format],
> -			   PPP_ADDR_BG_PACK_PATTERN);
> +		mdp_writel_dbg(mdp, regs->bg0, PPP_ADDR_BG0);
> +		mdp_writel_dbg(mdp, regs->bg1, PPP_ADDR_BG1);
> +		mdp_writel_dbg(mdp, regs->bg_ystride, PPP_ADDR_BG_YSTRIDE);
> +		mdp_writel_dbg(mdp, regs->bg_cfg, PPP_ADDR_BG_CFG);
> +		mdp_writel_dbg(mdp, regs->bg_pack, PPP_ADDR_BG_PACK_PATTERN);
>  	}
>  	flush_imgs(req, regs, src_file, dst_file);
> -	mdp_writel(mdp, 0x1000, MDP_DISPLAY0_START);
> +	mdp_writel_dbg(mdp, 0x1000, MDP_DISPLAY0_START);
>  	return 0;
>  }
> 
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
