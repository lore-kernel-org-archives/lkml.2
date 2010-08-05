Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905Ab0HEWZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:25:55 -0400
Received: from kroah.org ([198.145.64.141]:37748 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934062Ab0HEWYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:40 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/28] Driver core: move platform device creation helpers to .init.text (if MODULE=n)
Date: Thu,  5 Aug 2010 15:24:01 -0700
Message-Id: <1281047058-23716-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Platform devices should only be called by init code, so it should be
possible to move creation helpers to .init.text -- at least if modules
are disabled.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index ffcfd73..1bb8faa 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -357,7 +357,7 @@ EXPORT_SYMBOL_GPL(platform_device_unregister);
  *
  * Returns &struct platform_device pointer on success, or ERR_PTR() on error.
  */
-struct platform_device *platform_device_register_resndata(
+struct platform_device *__init_or_module platform_device_register_resndata(
 		struct device *parent,
 		const char *name, int id,
 		const struct resource *res, unsigned int num,
-- 
1.7.2

