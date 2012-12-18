Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab2LRReS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:34:18 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:52385 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab2LRReM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:34:12 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: kernel-janitors@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH RESEND 0/6] Remove incorrect usage of IS_ERR_OR_NULL on clk_get
Date: Wed, 19 Dec 2012 06:34:02 +1300
Message-Id: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend to include mailing lists.

As per the kernel docs, clk_get() cannot return NULL.

 * clk_get - lookup and obtain a reference to a clock producer.
 * @dev: device for clock "consumer"
 * @id: clock consumer ID
 *
 * Returns a struct clk corresponding to the clock producer, or
 * valid IS_ERR() condition containing errno.

This patch set replaces instances of IS_ERR_OR_NULL tests againt clk_get()
results with IS_ERR tests.

Tony Prisk (6):
  clk: omap: Fix incorrect usage of IS_ERR_OR_NULL
  clk: exynos: Fix incorrect usage of IS_ERR_OR_NULL
  clk: exynos: Fix incorrect usage of IS_ERR_OR_NULL
  clk: s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL
  clk: s5p-fimc: Fix incorrect usage of IS_ERR_OR_NULL
  clk: s5p-g2d: Fix incorrect usage of IS_ERR_OR_NULL

 arch/arm/plat-omap/dmtimer.c                   |    6 +++---
 drivers/gpu/drm/exynos/exynos_hdmi.c           |   10 +++++-----
 drivers/gpu/drm/exynos/exynos_mixer.c          |   14 +++++++-------
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    2 +-
 drivers/media/platform/s5p-g2d/g2d.c           |    4 ++--
 drivers/media/platform/s5p-tv/hdmi_drv.c       |   10 +++++-----
 drivers/media/platform/s5p-tv/mixer_drv.c      |   10 +++++-----
 drivers/media/platform/s5p-tv/sdo_drv.c        |   10 +++++-----
 8 files changed, 33 insertions(+), 33 deletions(-)

-- 
1.7.9.5

