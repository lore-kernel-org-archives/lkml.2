Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab0FUOMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 10:12:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54534 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639Ab0FUOMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 10:12:34 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Magnus Damm <damm@opensource.se>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/2] Driver core: move platform device creation helpers to .init.text (if MODULE=n)
Date: Mon, 21 Jun 2010 16:11:45 +0200
Message-Id: <1277129511-2732-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100618073950.GA12822@pengutronix.de>
References: <20100618073950.GA12822@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform devices should only be called by init code, so it should be
possible to move creation helpers to .init.text -- at least if modules
are disabled.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

for a x64_64_defconfig with CONFIG_MODULES disabled this introduces two new
section mismatches.  I already sent patches for those[1].

Best regards
Uwe


[1] one in this thread and the other can be found at

	http://thread.gmane.org/gmane.linux.kernel.wireless.general/52404/focus=52405

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
1.7.1

