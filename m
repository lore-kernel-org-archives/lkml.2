Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab2K2KLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:11:05 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:50173 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab2K2KK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:10:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v3 0/9] Media Controller capture driver for DM365
Date: Thu, 29 Nov 2012 11:12:05 +0100
Message-ID: <3827969.48rJ6ExhZb@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com>
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 November 2012 16:12:00 Prabhakar Lad wrote:
> From: Manjunath Hadli <manjunath.hadli@ti.com>

For staging, and provided that all parties involved understand that an API 
compatibility layer with the existing drivers/media/platform/davinci/ driver 
(called the "existing driver") will need to be provided when this media 
controller aware driver will move out of staging to drivers/media/ and replace 
the existing driver,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Mauro/Greg,
>  The below series of patches have gone through good amount of reviews, and
> agreed by Laurent, Hans and Sakari to be part of the staging tree. I am
> combining the patchs with the pull request so we can get them into the 3.8
> kernel. Please pull these patches.If you want a seperate pull request,
> please let me know.
> 
> This patch set adds media controller based capture driver for
> DM365.
> 
> This driver bases its design on Laurent Pinchart's Media Controller Design
> whose patches for Media Controller and subdev enhancements form the base.
> The driver also takes copious elements taken from Laurent Pinchart and
> others' OMAP ISP driver based on Media Controller. So thank you all the
> people who are responsible for the Media Controller and the OMAP ISP driver.
> 
> Also, the core functionality of the driver comes from the arago vpfe capture
> driver of which the isif capture was based on V4L2, with other drivers like
> ipipe, ipipeif and Resizer.
> 
> Changes for v2:
> 1: Migrated the driver for videobuf2 usage pointed Hans.
> 2: Changed the design as pointed by Laurent, Exposed one more subdevs
>    ipipeif and split the resizer subdev into three subdevs.
> 3: Rearrganed the patch sequence and changed the commit messages.
> 4: Changed the file architecture as pointed by Laurent.
> 
> Changes for v3:
> 1: Rebased on staging.
> 2: Seprated out patches which would go into staging.
> 
> The following changes since commit c6c22955f80f2db9614b01fe5a3d1cfcd8b3d848:
> 
>   [media] dma-mapping: fix dma_common_get_sgtable() conditional compilation
> (2012-11-27 09:42:31 -0200)
> 
> are available in the git repository at:
>   git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git vpfe_driver_staging
> 
> Manjunath Hadli (9):
>       davinci: vpfe: add v4l2 capture driver with media interface
>       davinci: vpfe: add v4l2 video driver support
>       davinci: vpfe: dm365: add IPIPEIF driver based on media framework
>       davinci: vpfe: dm365: add ISIF driver based on media framework
>       davinci: vpfe: dm365: add IPIPE support for media controller driver
>       davinci: vpfe: dm365: add IPIPE hardware layer support
>       davinci: vpfe: dm365: resizer driver based on media framework
>       davinci: vpfe: dm365: add build infrastructure for capture driver
>       davinci: vpfe: Add documentation and TODO
> 
>  drivers/staging/media/Kconfig                      |    2 +
>  drivers/staging/media/Makefile                     |    1 +
>  drivers/staging/media/davinci_vpfe/Kconfig         |    9 +
>  drivers/staging/media/davinci_vpfe/Makefile        |    3 +
>  drivers/staging/media/davinci_vpfe/TODO            |   34 +
>  .../staging/media/davinci_vpfe/davinci-vpfe-mc.txt |  154 ++
>  .../staging/media/davinci_vpfe/davinci_vpfe_user.h | 1290 ++++++++++++
>  drivers/staging/media/davinci_vpfe/dm365_ipipe.c   | 1863 +++++++++++++++++
> drivers/staging/media/davinci_vpfe/dm365_ipipe.h   |  179 ++
>  .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    | 1048 ++++++++++
>  .../staging/media/davinci_vpfe/dm365_ipipe_hw.h    |  559 ++++++
>  drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 1071 ++++++++++
>  drivers/staging/media/davinci_vpfe/dm365_ipipeif.h |  233 +++
>  .../media/davinci_vpfe/dm365_ipipeif_user.h        |   93 +
>  drivers/staging/media/davinci_vpfe/dm365_isif.c    | 2104 +++++++++++++++++
>  drivers/staging/media/davinci_vpfe/dm365_isif.h    |  203 ++
>  .../staging/media/davinci_vpfe/dm365_isif_regs.h   |  294 +++
>  drivers/staging/media/davinci_vpfe/dm365_resizer.c | 1999 +++++++++++++++++
>  drivers/staging/media/davinci_vpfe/dm365_resizer.h |  244 +++
>  drivers/staging/media/davinci_vpfe/vpfe.h          |   86 +
>  .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |  740 +++++++
>  .../staging/media/davinci_vpfe/vpfe_mc_capture.h   |   97 +
>  drivers/staging/media/davinci_vpfe/vpfe_video.c    | 1620 +++++++++++++++
>  drivers/staging/media/davinci_vpfe/vpfe_video.h    |  155 ++
>  24 files changed, 14081 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/media/davinci_vpfe/Kconfig
>  create mode 100644 drivers/staging/media/davinci_vpfe/Makefile
>  create mode 100644 drivers/staging/media/davinci_vpfe/TODO
>  create mode 100644 drivers/staging/media/davinci_vpfe/davinci-vpfe-mc.txt
>  create mode 100644 drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h
>  create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipe.c
>  create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipe.h
>  create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
>  create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.h
>  create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
>  create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipeif.h
>  create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipeif_user.h
>  create mode 100644 drivers/staging/media/davinci_vpfe/dm365_isif.c
>  create mode 100644 drivers/staging/media/davinci_vpfe/dm365_isif.h
>  create mode 100644 drivers/staging/media/davinci_vpfe/dm365_isif_regs.h
>  create mode 100644 drivers/staging/media/davinci_vpfe/dm365_resizer.c
>  create mode 100644 drivers/staging/media/davinci_vpfe/dm365_resizer.h
>  create mode 100644 drivers/staging/media/davinci_vpfe/vpfe.h
>  create mode 100644 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
>  create mode 100644 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h
>  create mode 100644 drivers/staging/media/davinci_vpfe/vpfe_video.c
>  create mode 100644 drivers/staging/media/davinci_vpfe/vpfe_video.h

-- 
Regards,

Laurent Pinchart

