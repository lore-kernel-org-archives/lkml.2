Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab1A0Maj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 07:30:39 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:59784 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1A0Mai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 07:30:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, clemens@ladisch.de
Subject: [PATCH v8 00/12] Media controller (core and V4L2)
Date: Thu, 27 Jan 2011 13:30:25 +0100
Message-Id: <1296131437-29954-1-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

Here is the eighth version of the media controller core and V4L2 patches.

Quick reminder for those who missed the previous version. let me quote the
documentation (Documentation/DocBook/v4l/media-controller.xml).

"Discovering a [media] device internal topology, and configuring it at runtime,
is one of the goals of the media controller API. To achieve this, hardware
devices are modelled as an oriented graph of building blocks called entities
connected through pads."

The code has been extensively reviewed by the V4L community, and this version
is the first one to incorporate comments from the ALSA community (big thanks
to Mark Brown and Clemens Ladisch). Two issues are not fully addressed yet,
namely power management (I need to discuss this some more with the ALSA
developers to really understand their requirements) and entities type names.
I'm still posting this for review, as other developers have showed interest in
commenting on the code.

I want to emphasize once again that the media controller API does not replace
the V4L, DVB or ALSA APIs. It complements them.

The first user of the media controller API is the OMAP3 ISP driver. You can
find it (as well as these patches and other V4L-specific patches) in a git tree
at http://git.linuxtv.org/pinchartl/media.git (media-0005-omap3isp branch). The
OMAP3 ISP driver patches are regularly posted for review on the linux-media
list.

Laurent Pinchart (11):
  media: Media device node support
  media: Media device
  media: Entities, pads and links
  media: Entity use count
  media: Media device information query
  media: Entities, pads and links enumeration
  media: Links setup
  media: Pipelines and media streams
  v4l: Add a media_device pointer to the v4l2_device structure
  v4l: Make video_device inherit from media_entity
  v4l: Make v4l2_subdev inherit from media_entity

Sakari Ailus (1):
  media: Entity graph traversal

 Documentation/ABI/testing/sysfs-bus-media          |    6 +
 Documentation/DocBook/media-entities.tmpl          |   24 +
 Documentation/DocBook/media.tmpl                   |    3 +
 Documentation/DocBook/v4l/media-controller.xml     |   89 ++++
 Documentation/DocBook/v4l/media-func-close.xml     |   59 +++
 Documentation/DocBook/v4l/media-func-ioctl.xml     |  116 +++++
 Documentation/DocBook/v4l/media-func-open.xml      |   94 ++++
 .../DocBook/v4l/media-ioc-device-info.xml          |  133 +++++
 .../DocBook/v4l/media-ioc-enum-entities.xml        |  308 +++++++++++
 Documentation/DocBook/v4l/media-ioc-enum-links.xml |  207 ++++++++
 Documentation/DocBook/v4l/media-ioc-setup-link.xml |   93 ++++
 Documentation/media-framework.txt                  |  353 +++++++++++++
 Documentation/video4linux/v4l2-framework.txt       |   72 +++-
 drivers/media/Kconfig                              |   13 +
 drivers/media/Makefile                             |   10 +-
 drivers/media/media-device.c                       |  382 ++++++++++++++
 drivers/media/media-devnode.c                      |  321 ++++++++++++
 drivers/media/media-entity.c                       |  536 ++++++++++++++++++++
 drivers/media/video/v4l2-dev.c                     |   49 ++-
 drivers/media/video/v4l2-device.c                  |   52 ++-
 drivers/media/video/v4l2-subdev.c                  |   41 ++-
 include/linux/Kbuild                               |    1 +
 include/linux/media.h                              |  132 +++++
 include/media/media-device.h                       |   95 ++++
 include/media/media-devnode.h                      |   97 ++++
 include/media/media-entity.h                       |  147 ++++++
 include/media/v4l2-dev.h                           |    7 +
 include/media/v4l2-device.h                        |    4 +
 include/media/v4l2-subdev.h                        |   10 +
 29 files changed, 3428 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-media
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

