Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab1BPV4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 16:56:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34029 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab1BPVz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 16:55:59 -0500
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: kernel@pengutronix.de
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 1/2] kernel.h: introduce BUILD_BUG_ON_NOT_SAME_TYPE
Date: Wed, 16 Feb 2011 22:55:50 +0100
Message-Id: <1297893351-2900-2-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297893351-2900-1-git-send-email-mkl@pengutronix.de>
References: <1297893351-2900-1-git-send-email-mkl@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces BUILD_BUG_ON_NOT_SAME_TYPE which forces a compilation
error if the two supplied variables don't have the same type.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/linux/kernel.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2fe6e84..b637d57 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -612,6 +612,8 @@ extern int __build_bug_on_failed;
 	} while(0)
 #endif
 
+#define BUILD_BUG_ON_NOT_SAME_TYPE(a, b) BUILD_BUG_ON(!__same_type((a), (b)));
+
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
 
-- 
1.7.2.3

