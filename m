Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab1BNMtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 07:49:23 -0500
Received: from ams-iport-1.cisco.com ([144.254.224.140]:9992 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab1BNMtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 07:49:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgQBAAK0WE2Q/khLgWdsb2JhbACXKo5cFQEBFiIknlCaaIVeBIt/gzg
X-IronPort-AV: E=Sophos;i="4.60,469,1291593600"; 
   d="scan'208";a="76211737"
From: Hans Verkuil <hansverk@cisco.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v9 00/12] Media controller (core and V4L2)
Date: Mon, 14 Feb 2011 13:49:45 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.32-23-generic; KDE/4.4.5; x86_64; ; )
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com
References: <1297686067-9666-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686067-9666-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102141349.45127.hansverk@cisco.com>
X-OriginalArrivalTime: 14 Feb 2011 12:49:17.0390 (UTC) FILETIME=[975486E0:01CBCC45]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is my

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

for this patch series.

Regards,

	Hans

On Monday, February 14, 2011 13:20:55 Laurent Pinchart wrote:
> Hi everybody,
> 
> Here is the ninth version of the media controller core and V4L2 patches.
> 
> Quick reminder for those who missed the previous version. let me quote the
> documentation (Documentation/DocBook/v4l/media-controller.xml).
> 
> "Discovering a [media] device internal topology, and configuring it at 
runtime,
> is one of the goals of the media controller API. To achieve this, hardware
> devices are modelled as an oriented graph of building blocks called entities
> connected through pads."
> 
> The code has been extensively reviewed by the V4L community, and this 
version
> is the first one to incorporate comments from the ALSA community (big thanks
> to Mark Brown and Clemens Ladisch). Two issues are not fully addressed yet,
> namely power management (I need to discuss this some more with the ALSA
> developers to really understand their requirements) and entities type names.
> I'm still posting this for review, as other developers have showed interest 
in
> commenting on the code.
> 
> I want to emphasize once again that the media controller API does not 
replace
> the V4L, DVB or ALSA APIs. It complements them.
> 
> The first user of the media controller API is the OMAP3 ISP driver. You can
> find it (as well as these patches and other V4L-specific patches) in a git 
tree
> at http://git.linuxtv.org/pinchartl/media.git (media-0005-omap3isp branch). 
The
> OMAP3 ISP driver patches are regularly posted for review on the linux-media
> list.
> 
> Laurent Pinchart (11):
>   media: Media device node support
>   media: Media device
>   media: Entities, pads and links
>   media: Entity use count
>   media: Media device information query
>   media: Entities, pads and links enumeration
>   media: Links setup
>   media: Pipelines and media streams
>   v4l: Add a media_device pointer to the v4l2_device structure
>   v4l: Make video_device inherit from media_entity
>   v4l: Make v4l2_subdev inherit from media_entity
> 
> Sakari Ailus (1):
>   media: Entity graph traversal
> 
>  Documentation/ABI/testing/sysfs-bus-media          |    6 +
>  Documentation/DocBook/media-entities.tmpl          |   24 +
>  Documentation/DocBook/media.tmpl                   |    3 +
>  Documentation/DocBook/v4l/media-controller.xml     |   89 ++++
>  Documentation/DocBook/v4l/media-func-close.xml     |   59 +++
>  Documentation/DocBook/v4l/media-func-ioctl.xml     |  116 +++++
>  Documentation/DocBook/v4l/media-func-open.xml      |   94 ++++
>  .../DocBook/v4l/media-ioc-device-info.xml          |  133 +++++
>  .../DocBook/v4l/media-ioc-enum-entities.xml        |  308 +++++++++++
>  Documentation/DocBook/v4l/media-ioc-enum-links.xml |  207 ++++++++
>  Documentation/DocBook/v4l/media-ioc-setup-link.xml |   93 ++++
>  Documentation/media-framework.txt                  |  353 +++++++++++++
>  Documentation/video4linux/v4l2-framework.txt       |   72 +++-
>  drivers/media/Kconfig                              |   13 +
>  drivers/media/Makefile                             |    6 +
>  drivers/media/media-device.c                       |  382 ++++++++++++++
>  drivers/media/media-devnode.c                      |  321 ++++++++++++
>  drivers/media/media-entity.c                       |  536 
++++++++++++++++++++
>  drivers/media/video/v4l2-dev.c                     |   49 ++-
>  drivers/media/video/v4l2-device.c                  |   49 ++-
>  drivers/media/video/v4l2-subdev.c                  |   28 +-
>  include/linux/Kbuild                               |    1 +
>  include/linux/media.h                              |  132 +++++
>  include/media/media-device.h                       |   95 ++++
>  include/media/media-devnode.h                      |   97 ++++
>  include/media/media-entity.h                       |  151 ++++++
>  include/media/v4l2-dev.h                           |    7 +
>  include/media/v4l2-device.h                        |    4 +
>  include/media/v4l2-subdev.h                        |    6 +
>  29 files changed, 3413 insertions(+), 21 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-media
>  create mode 100644 Documentation/DocBook/v4l/media-controller.xml
>  create mode 100644 Documentation/DocBook/v4l/media-func-close.xml
>  create mode 100644 Documentation/DocBook/v4l/media-func-ioctl.xml
>  create mode 100644 Documentation/DocBook/v4l/media-func-open.xml
>  create mode 100644 Documentation/DocBook/v4l/media-ioc-device-info.xml
>  create mode 100644 Documentation/DocBook/v4l/media-ioc-enum-entities.xml
>  create mode 100644 Documentation/DocBook/v4l/media-ioc-enum-links.xml
>  create mode 100644 Documentation/DocBook/v4l/media-ioc-setup-link.xml
>  create mode 100644 Documentation/media-framework.txt
>  create mode 100644 drivers/media/media-device.c
>  create mode 100644 drivers/media/media-devnode.c
>  create mode 100644 drivers/media/media-entity.c
>  create mode 100644 include/linux/media.h
>  create mode 100644 include/media/media-device.h
>  create mode 100644 include/media/media-devnode.h
>  create mode 100644 include/media/media-entity.h
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
