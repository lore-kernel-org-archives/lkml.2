Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab2K1LWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 06:22:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab2K1LWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 06:22:34 -0500
Date: Wed, 28 Nov 2012 09:22:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>, <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v3 9/9] davinci: vpfe: Add documentation and TODO
Message-ID: <20121128092213.4bd0870f@redhat.com>
In-Reply-To: <1354099329-20722-10-git-send-email-prabhakar.lad@ti.com>
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com>
	<1354099329-20722-10-git-send-email-prabhakar.lad@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Em Wed, 28 Nov 2012 16:12:09 +0530
Prabhakar Lad <prabhakar.csengg@gmail.com> escreveu:

> +Introduction
> +============
> +
> +This file documents the Texas Instruments Davinci Video processing Front End
> +(VPFE) driver located under drivers/media/platform/davinci. The original driver
> +exists for Davinci VPFE, which is now being changed to Media Controller
> +Framework.

Hmm... please correct me if I'm wrong, but are you wanting to replace an existing
driver at drivers/media/platform/davinci, by another one at staging that has
lots of known issues, as pointed at your TODO????

If so, please don't do that. Replacing a driver by some other one is generally
a very bad idea, especially in this case, where the new driver has clearly several
issues, the main one being to define its own proprietary and undocumented API:

> +As of now since the interface will undergo few changes all the include
> +files are present in staging itself, to build for dm365 follow below steps,
> +
> +- copy vpfe.h from drivers/staging/media/davinci_vpfe/ to
> +  include/media/davinci/ folder for building the uImage.
> +- copy davinci_vpfe_user.h from drivers/staging/media/davinci_vpfe/ to
> +  include/uapi/linux/davinci_vpfe.h, and add a entry in Kbuild (required
> +  for building application).
> +- copy dm365_ipipeif_user.h from drivers/staging/media/davinci_vpfe/ to
> +  include/uapi/linux/dm365_ipipeif.h and a entry in Kbuild (required
> +  for building application).

Among other things, with those ugly and very likely mandatory API calls:

>+/*
>+ * Private IOCTL
>+ * VIDIOC_VPFE_IPIPEIF_S_CONFIG: Set IPIEIF configuration
>+ * VIDIOC_VPFE_IPIPEIF_G_CONFIG: Get IPIEIF configuration
>+ */
>+#define VIDIOC_VPFE_IPIPEIF_S_CONFIG \
>+	_IOWR('I', BASE_VIDIOC_PRIVATE + 1, struct ipipeif_params)
>+#define VIDIOC_VPFE_IPIPEIF_G_CONFIG \
>+	_IOWR('I', BASE_VIDIOC_PRIVATE + 2, struct ipipeif_params)
>+
>+#endif	

I remember we rejected already drivers like that with obscure "S_CONFIG"
private ioctl that were suspect to send a big initialization undocumented
blob to the driver, as only the vendor's application would be able to use
such driver.

So, instead, of submitting it to staging, you should be sending incremental
patches for the existing driver, adding newer functionality there, and 
using the proper V4L2 API, with makes life easier for reviewers and
application developers.

Regards,
Mauro
