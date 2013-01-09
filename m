Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab3AINlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 08:41:45 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:59275 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436Ab3AINlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 08:41:44 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, Sekhar Nori <nsekhar@ti.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH RFC 0/3] vpif capture support for async subdevice probing
Date: Wed,  9 Jan 2013 19:11:24 +0530
Message-Id: <1357738887-8701-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for vpif capture driver to support
asynchronously register subdevices. The second patch add support for
tvp514x decoder to support v4l-async and the last patch adds support
for da850 evm to support v4l-async for vpif capture.

This patch is based on v4l2-async patch
(http://www.spinics.net/lists/linux-media/msg58420.html) from Guennadi.

Need for this support:
Currently bridge device drivers register devices for all subdevices 
synchronously, tupically, during their probing. E.g. if an I2C CMOS sensor 
is attached to a video bridge device, the bridge driver will create an I2C 
device and wait for the respective I2C driver to probe. This makes linking 
of devices straight forward, but this approach cannot be used with 
intrinsically asynchronous and unordered device registration systems like 
the Flattened Device Tree.

Similar impletation is to be done for vpif disaply, based on review comments
on this series.

Lad, Prabhakar (3):
  davinci: vpif: capture: add V4L2-async support
  tvp514x: support asynchronous probing
  ARM: da850/omap-l138: vpif capture convert to asynchronously register
    of subdev

 arch/arm/mach-davinci/board-da850-evm.c       |   57 +++++++-
 drivers/media/i2c/tvp514x.c                   |   20 ++-
 drivers/media/platform/davinci/vpif_capture.c |  171 ++++++++++++++++++-------
 drivers/media/platform/davinci/vpif_capture.h |    2 +
 include/media/davinci/vpif_types.h            |    2 +
 5 files changed, 192 insertions(+), 60 deletions(-)

-- 
1.7.4.1

