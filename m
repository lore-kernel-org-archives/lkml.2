Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab1LNOBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:01:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56233 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab1LNOA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:00:58 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [RFC PATCH v2 0/7] media: introduce object detection(OD) driver
Date: Wed, 14 Dec 2011 22:00:06 +0800
Message-Id: <1323871214-25435-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These v2 patches(against -next tree) introduce v4l2 based object
detection(OD) device driver, and enable face detection hardware[1]
on omap4 SoC.. The idea of implementing it on v4l2 is from from
Alan Cox, Sylwester and Greg-Kh.

For verification purpose, I write one user space utility[2] to
test the module and driver, follows its basic functions:

	- detect faces in input grayscal picture(PGM raw, 320 by 240)
	- detect faces in input y8 format video stream
	- plot a rectangle to mark the detected faces, and save it as
	another same format picture or video stream

Looks the performance of the module is not bad, see some detection
results on the link[3][4].

Face detection can be used to implement some interesting applications
(camera, face unlock, baby monitor, ...).

v2<-v1:
	- extend face detection API to object detection API
	- extend face detection generic module to object detection module
	- introduce subdevice and media entity to object detection module
	- some minor fixes

TODO:
	- implement OD setting interfaces with v4l2 controls or
	ext controls

 arch/arm/mach-omap2/devices.c              |   33 +
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   81 +++
 drivers/media/video/Kconfig                |    6 +
 drivers/media/video/Makefile               |    2 +
 drivers/media/video/odif/Kconfig           |   13 +
 drivers/media/video/odif/Makefile          |    2 +
 drivers/media/video/odif/fdif_omap4.c      |  685 +++++++++++++++++++++
 drivers/media/video/odif/odif.c            |  890 ++++++++++++++++++++++++++++
 drivers/media/video/odif/odif.h            |  157 +++++
 drivers/media/video/v4l2-ioctl.c           |   72 +++-
 drivers/media/video/videobuf2-dma-contig.c |    1 +
 drivers/media/video/videobuf2-memops.c     |    1 -
 drivers/media/video/videobuf2-page.c       |  117 ++++
 include/linux/videodev2.h                  |  124 ++++
 include/media/v4l2-ioctl.h                 |    6 +
 include/media/videobuf2-page.h             |   20 +
 16 files changed, 2207 insertions(+), 3 deletions(-)



thanks,
--
Ming Lei

[1], Ch9 of OMAP4 Technical Reference Manual
[2], http://kernel.ubuntu.com/git?p=ming/fdif.git;a=shortlog;h=refs/heads/v4l2-fdif
[3], http://kernel.ubuntu.com/~ming/dev/fdif/output
[4], All pictures are taken from http://www.google.com/imghp
and converted to pnm from jpeg format, only for test purpose.

