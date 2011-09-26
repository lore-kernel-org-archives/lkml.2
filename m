Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab1IZJdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:33:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62337 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1IZJdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:33:07 -0400
Date: Mon, 26 Sep 2011 11:32:53 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Nicolas Ferre <nicolas.ferre@atmel.com>
cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Josh Wu <josh.wu@atmel.com>, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3 2/2] at91: add Atmel ISI and ov2640 support on
 sam9m10/sam9g45 board.
In-Reply-To: <4E804440.7030709@atmel.com>
Message-ID: <Pine.LNX.4.64.1109261130270.9168@axis700.grange>
References: <1316664661-11383-1-git-send-email-josh.wu@atmel.com>
 <1316664661-11383-2-git-send-email-josh.wu@atmel.com>
 <Pine.LNX.4.64.1109220911500.11164@axis700.grange> <20110924052609.GI29998@game.jcrosoft.org>
 <4E804440.7030709@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:NARq7eXkWuOw3OT1qjomIjcbKBqj/MSJcJeGkMo5bgu
 eLyCu5a7wB3ohzoihDjM5/OFwUk/fIvRMOyRPVjRf1uDUaRDiU
 WUyiiupVolgExluTvoQtnWL5Ptr9MoNy77QJEoP1nmcOP85tkX
 Fl7pRo/cwgiOiscPkheaCIbYRgAB9x2MFXJe218EYA+Ju7aCJO
 0/DKQQUtDXrljimXdYVAXwPmv31r+7uS+7TSdR/M54CDLRQr56
 Ijo+wJKv0dHu2dYPpv/kRUhmUzosvpVQi52Zp6a3YVjD+dnNjh
 Sn2luMiHHkIi4Rgxi4soPanhFML9QFNZ2545/0Gcnleodj+ogg
 VzOTJBivTPrnELBXULNvy/w0Oyboeo0hlRtultzXGOG+f/uZBH
 GtdW+3nZtckvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas

On Mon, 26 Sep 2011, Nicolas Ferre wrote:

> Le 24/09/2011 07:26, Jean-Christophe PLAGNIOL-VILLARD :
> > On 09:35 Thu 22 Sep     , Guennadi Liakhovetski wrote:
> >> On Thu, 22 Sep 2011, Josh Wu wrote:
> >>
> >>> This patch
> >>> 1. add ISI_MCK parent setting code when add ISI device.
> >>> 2. add ov2640 support on board file.
> >>> 3. define isi_mck clock in sam9g45 chip file.
> >>>
> >>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> >>> ---
> >>>  arch/arm/mach-at91/at91sam9g45.c         |    3 +
> >>>  arch/arm/mach-at91/at91sam9g45_devices.c |  105 +++++++++++++++++++++++++++++-
> >>>  arch/arm/mach-at91/board-sam9m10g45ek.c  |   85 ++++++++++++++++++++++++-
> >>>  arch/arm/mach-at91/include/mach/board.h  |    3 +-
> >>
> >> Personally, I think, it would be better to separate this into two patches 
> >> at least: one for at91 core and one for the specific board, but that's up 
> >> to arch maintainers to decide.
> >>
> >> You also want to patch arch/arm/mach-at91/at91sam9263_devices.c, don't 
> >> you?
> > agreed
> 
> No, I am not sure. The IP is not the same between 9263 and 9g45/9m10. So
> this inclusion will not apply.

Sorry, that's not what I meant. This patch changes a function declaration:

diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
index ed544a0..276d63a 100644
--- a/arch/arm/mach-at91/include/mach/board.h
+++ b/arch/arm/mach-at91/include/mach/board.h
@@ -183,7 +183,8 @@ extern void __init at91_add_device_lcdc(struct 
atmel_lcdfb_info *data);
 extern void __init at91_add_device_ac97(struct ac97c_platform_data 
*data);
 
  /* ISI */
-extern void __init at91_add_device_isi(void);
+struct isi_platform_data;
+extern void __init at91_add_device_isi(struct isi_platform_data *data);
 
  /* Touchscreen Controller */
 struct at91_tsadcc_data {

but doesn't change that function implementation in at91sam9263_devices.c, 
which will break compilation, AFAICS.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
