Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab0KYC2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 21:28:12 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:35034 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab0KYC2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 21:28:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, lennart@poettering.net
Subject: [RFC/PATCH v6 00/12] Media controller (core and V4L2)
Date: Thu, 25 Nov 2010 03:28:07 +0100
Message-Id: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

Here is the sixth version of the media controller core and V4L2 patches, and
the first one to be sent outside of the linux-media mailing list.

For those who haven't heard about the media controller yet, let me quote the
documentation (Documentation/DocBook/v4l/media-controller.xml).

"Discovering a [media] device internal topology, and configuring it at runtime,
is one of the goals of the media controller API. To achieve this, hardware
devices are modelled as an oriented graph of building blocks called entities
connected through pads."

While originally developed to solve problems found in V4L and embedded devices,
the API aims at being useful (and hopefully used) by audio drivers as well,
especially for devices that combine video and audio capabilities.

I want to emphasize that the media controller API does *not* replace the V4L,
DVB or ALSA APIs. It complements them.

The first user of the media controller API is the OMAP3 ISP driver. You can
find it (as well as these patches and other V4L-specific patches) in a git tree
at http://git.linuxtv.org/pinchartl/media.git (media-0004-omap3isp branch). The
OMAP3 ISP driver patches are regularly posted for review on the linux-media
list.

I'm looking forward to the storm of comments that will start in response to
this e-mail. Hopefully it won't hurt (too much) :-).

Laurent Pinchart (10):
  media: Media device node support
  media: Media device
  media: Entities, pads and links
  media: Media device information query
  media: Entities, pads and links enumeration
  media: Links setup
  media: Entity locking and pipeline management
  v4l: Add a media_device pointer to the v4l2_device structure
  v4l: Make video_device inherit from media_entity
  v4l: Make v4l2_subdev inherit from media_entity

Sakari Ailus (2):
  media: Entity graph traversal
  media: Reference count and power handling

 Documentation/DocBook/media-entities.tmpl          |   24 +
 Documentation/DocBook/media.tmpl                   |    3 +
 Documentation/DocBook/v4l/media-controller.xml     |   89 +++
 Documentation/DocBook/v4l/media-func-close.xml     |   59 ++
 Documentation/DocBook/v4l/media-func-ioctl.xml     |  116 ++++
 Documentation/DocBook/v4l/media-func-open.xml      |   94 +++
 .../DocBook/v4l/media-ioc-device-info.xml          |  133 ++++
 .../DocBook/v4l/media-ioc-enum-entities.xml        |  287 +++++++++
 Documentation/DocBook/v4l/media-ioc-enum-links.xml |  202 ++++++
 Documentation/DocBook/v4l/media-ioc-setup-link.xml |   90 +++
 Documentation/media-framework.txt                  |  380 +++++++++++
 Documentation/video4linux/v4l2-framework.txt       |   72 ++-
 drivers/media/Kconfig                              |   13 +
 drivers/media/Makefile                             |   10 +-
 drivers/media/media-device.c                       |  379 +++++++++++
 drivers/media/media-devnode.c                      |  321 +++++++++
 drivers/media/media-entity.c                       |  680 ++++++++++++++++++++
 drivers/media/video/v4l2-dev.c                     |   47 ++-
 drivers/media/video/v4l2-device.c                  |   52 ++-
 drivers/media/video/v4l2-subdev.c                  |   41 ++-
 include/linux/Kbuild                               |    1 +
 include/linux/media.h                              |  127 ++++
 include/media/media-device.h                       |   92 +++
 include/media/media-devnode.h                      |   97 +++
 include/media/media-entity.h                       |  144 +++++
 include/media/v4l2-dev.h                           |    7 +
 include/media/v4l2-device.h                        |    4 +
 include/media/v4l2-subdev.h                        |   10 +
 28 files changed, 3547 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/media-controller.xml
 create mode 100644 Documentation/DocBook/v4l/media-func-close.xml
 create mode 100644 Documentation/DocBook/v4l/media-func-ioctl.xml
 create mode 100644 Documentation/DocBook/v4l/media-func-open.xml
 create mode 100644 Documentation/DocBook/v4l/media-ioc-device-info.xml
 create mode 100644 Documentation/DocBook/v4l/media-ioc-enum-entities.xml
 create mode 100644 Documentation/DocBook/v4l/media-ioc-enum-links.xml
 create mode 100644 Documentation/DocBook/v4l/media-ioc-setup-link.xml
 create mode 100644 Documentation/media-framework.txt
 create mode 100644 drivers/media/media-device.c
 create mode 100644 drivers/media/media-devnode.c
 create mode 100644 drivers/media/media-entity.c
 create mode 100644 include/linux/media.h
 create mode 100644 include/media/media-device.h
 create mode 100644 include/media/media-devnode.h
 create mode 100644 include/media/media-entity.h

-- 
Regards,

Laurent Pinchart

