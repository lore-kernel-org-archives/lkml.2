Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab1BRJWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:22:37 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:38477 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618Ab1BRJWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:22:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qBgZj0Ltd2Jc985fHmPf9giL6UUP51cybboyMmGjhVpJztX4hbsNyVL9mlqbQomAoN
         ZUj5SGIz8Tdf9jpAq/gH36eXaqucJpQuiDOrlvbqgDJOSO+q3CTRr9/1oLuURh5te/BQ
         VvBS/fLXeJtqhFQG47f54m7Of6SV7ehzCDnxY=
MIME-Version: 1.0
In-Reply-To: <1297865452-32181-4-git-send-email-s.hauer@pengutronix.de>
References: <1297865452-32181-1-git-send-email-s.hauer@pengutronix.de>
	<1297865452-32181-4-git-send-email-s.hauer@pengutronix.de>
Date: Fri, 18 Feb 2011 17:22:09 +0800
Message-ID: <AANLkTina46_CMvB_9cqc4=PvcPxaV_BQ_H_ghJZFFxg8@mail.gmail.com>
Subject: Re: [PATCH 3/7] Add i.MX5 framebuffer driver
From: Jason Chen <weitway@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, Sasha,

> +       if (var->vmode & FB_VMODE_ODD_FLD_FIRST) /* PAL */
> +               sig_cfg.odd_field_first = 1;
> +       if (var->sync & FB_SYNC_EXT)
> +               sig_cfg.ext_clk = 1;
> +       if (var->sync & FB_SYNC_HOR_HIGH_ACT)
> +               sig_cfg.Hsync_pol = 1;
Please remove FB_SYNC_EXT support.

+static void imx_ipu_fb_disable_overlay(struct fb_info *ovl)
+{
+       struct imx_ipu_fb_info *mxc_ovl = ovl->par;
+
+       if (!mxc_ovl->enabled)
+               return;
+
+       ipu_dp_disable_fg(mxc_ovl->dp);
+       ipu_wait_for_interrupt(451, 100);
+       ipu_idmac_disable_channel(mxc_ovl->ipu_ch);
+       ipu_dmfc_disable_channel(mxc_ovl->dmfc);
+       mxc_ovl->enabled = 0;
+}
Had better has a definition of ipu irq 451.

Jason Chen
BRs
