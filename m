Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991Ab1F1QEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:04:25 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:51841 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758894Ab1F1QCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:02:12 -0400
X-Sasl-enc: JtoR6hUkfZs+dbtGE7jxRJR5eu6aUq3U75XQ1Rw5BW++ 1309276931
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg KH <gregkh@suse.de>, David Airlie <airlied@linux.ie>,
        <stable@kernel.org>
Subject: [PATCH 3/9] drivers/base/platform.c: don't mark platform_device_register_resndata() as __init_or_module
Date: Tue, 28 Jun 2011 09:02:00 -0700
Message-Id: <1309276926-1327-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309276926-1327-1-git-send-email-gregkh@suse.de>
References: <20110628153911.GD32710@kroah.com>
 <1309276926-1327-1-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

This reverts 737a3bb9416ce2a7c7a4 ("Driver core: move platform device
creation helpers to .init.text (if MODULE=n)").  That patch assumed that
platform_device_register_resndata() is only ever called from __init code
but that isn't true in the case ioctl->drm_ioctl->radeon_cp_init().

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=35192

Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reported-by: Anthony Basile <blueness@gentoo.org>
Cc: Greg KH <gregkh@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 1c291af..6040717 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -367,7 +367,7 @@ EXPORT_SYMBOL_GPL(platform_device_unregister);
  *
  * Returns &struct platform_device pointer on success, or ERR_PTR() on error.
  */
-struct platform_device *__init_or_module platform_device_register_resndata(
+struct platform_device *platform_device_register_resndata(
 		struct device *parent,
 		const char *name, int id,
 		const struct resource *res, unsigned int num,
-- 
1.7.5.4

