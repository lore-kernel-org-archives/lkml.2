Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415Ab2CFNL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 08:11:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50481 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758224Ab2CFNLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 08:11:25 -0500
Date: Tue, 6 Mar 2012 14:11:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Alex Gershgorin <alexg@meprolight.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: mx3-camera
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8906@MEP-EXCH.meprolight.com>
Message-ID: <Pine.LNX.4.64.1203061406500.9300@axis700.grange>
References: <4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8906@MEP-EXCH.meprolight.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:jxSvHg1JlLzlPsZg7yjcLgcrtxRlOdGq2zmnr6zFttH
 ULYCoLmqiBgEvsHaLtkbIH2ikZ9B5ttSXXkeAXpywqtW0yTJtO
 u0fzfymMQ9HFMC6Wxd/xX/RWyM3aEJfAqWcvWM/oUhCgHit3Y7
 ORwPqaaCxfjDbMHpDPJAvUJobn3tiue+TR91rXjPdQF+jmYzoG
 trTCRZ9gBVSG1qQHNtBS+cVVr9PHmYcFVdxhi9blGXy4j6Vyf9
 eD1FRHVzORgYQpA/GMOPBNzDmadUrTgPOD/2FfTKdrUTT2U6wy
 aYJAPh7xPbq6X45JXKHBHwcbA7VdehyckxLmn6tktwF6byDltk
 bv2fENbyAF+YP5Zz1jFNSyZ8uAvYzTkhS69xlWto44qYLzzC77
 1XcxNkX7unYhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex

(adding v4l and Sascha to CC)

On Tue, 6 Mar 2012, Alex Gershgorin wrote:

> Hi Guennadi,
> 
> I'm working on I.MX35 PDK platform with use 3.3.0-rc6 version of the Linux Kernel.  
> Here is my Kernel boot message
> 
> "Linux video capture interface: v2.00
> mx3-camera: probe of mx3-camera.0 failed with error -2"
> 
> This error comes from probe function of mx3 camera host driver.
> Precisely in this part of the code:
>  
> mx3_cam->clk = clk_get(&pdev->dev, NULL);
> if (IS_ERR(mx3_cam->clk)) {
> 	err = PTR_ERR(mx3_cam->clk);
> 	goto eclkget;
> }

I think, the reason is, that the i.MX35 platform doesn't register a camera 
clock, similar to i.MX31 (arch/arm/mach-imx/clock-imx31.c):

	_REGISTER_CLOCK("mx3-camera.0", NULL, csi_clk)

Thanks
Guennadi

> I will be glad for any help.
> 
> Regards,
> Alex Gershgorin

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
