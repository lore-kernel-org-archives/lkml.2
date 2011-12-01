Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1LAN7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 08:59:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43915 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab1LAN7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 08:59:11 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Vinod Koul <vinod.koul@intel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Valentin Longchamp <valentin.longchamp@keymile.com>,
        Daniel Mack <daniel@caiaq.de>, Eric Benard <eric@eukrea.com>
Subject: [PATCH] video IPUv1 fixes for different display connections
Date: Thu,  1 Dec 2011 14:58:50 +0100
Message-Id: <1322747932-24943-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.7.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series fixes the display connections to the IPU on
i.MX3 boards. The connection to the display is completely independend
of the internal pixel format in the framebuffer. The driver instead
changes the IPU <-> Display mapping dependent on the pixelformat
which is wrong.
The following patch makes 16bpp and 32bpp modes possible on both
RGB666 and RGB888 connected displays.
The burstsize setting for 32bpp was configured wrong, so 32bpp
modes have obviously never been tested.

Not for stable since all in kernel boards seem to work.

Sascha Hauer (2):
      i.MX IPU DMA: Fix wrong burstsize settings
      video i.MX IPU: Fix display connections

 arch/arm/plat-mxc/include/mach/mx3fb.h |   15 ++++++++
 drivers/dma/ipu/ipu_idmac.c            |   25 +------------
 drivers/video/mx3fb.c                  |   61 +++++++++++--------------------
 3 files changed, 38 insertions(+), 63 deletions(-)
