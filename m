Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab2K2UpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:45:20 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:63515 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2K2UpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:45:17 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de
Cc: backports@vger.kernel.org, alexander.stein@systec-electronic.com,
        brudley@broadcom.com, rvossen@broadcom.com, arend@broadcom.com,
        frankyl@broadcom.com, kanyan@broadcom.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, srinidhi.kasagar@stericsson.com,
        linus.walleij@linaro.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/6] drivers: convert struct spinlock to spinlock_t
Date: Thu, 29 Nov 2012 12:45:04 -0800
Message-Id: <1354221910-22493-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Turns out a few drivers have strayed away from using the
spinlock_t typedef and decided to use struct spinlock
directly. This series converts these drivers to use
spinlock_t. Each change has been compile tested with
allmodconfig and sparse checked. Driver developers
may want to look at the compile error output / sparse
error report supplied in each commit log, in particular
brcmfmac and i915, there are quite a few things that
are not related to this change that the developers
can clean up / fix.

Luis R. Rodriguez (6):
  ux500: convert struct spinlock to spinlock_t
  i915: convert struct spinlock to spinlock_t
  s5p-fimc: convert struct spinlock to spinlock_t
  s5p-jpeg: convert struct spinlock to spinlock_t
  brcmfmac: convert struct spinlock to spinlock_t
  ie6xx_wdt: convert struct spinlock to spinlock_t

 drivers/crypto/ux500/cryp/cryp.h               |    4 ++--
 drivers/crypto/ux500/hash/hash_alg.h           |    4 ++--
 drivers/gpu/drm/i915/i915_drv.h                |    4 ++--
 drivers/media/platform/s5p-fimc/mipi-csis.c    |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.h    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h |    2 +-
 drivers/watchdog/ie6xx_wdt.c                   |    2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

-- 
1.7.10.4

