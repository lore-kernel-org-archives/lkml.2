Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975Ab2C2VNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:13:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33747 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933906Ab2C2VMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:12:54 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel@pengutronix.de, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 07/17] mfd: mark const init data with __initconst instead of __initdata
Date: Thu, 29 Mar 2012 23:12:24 +0200
Message-Id: <1333055554-31300-7-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <20120329211131.GA31250@pengutronix.de>
References: <20120329211131.GA31250@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As long as there is no other non-const variable marked __initdata in the
same compilation unit it doesn't hurt. If there were one however
compilation would fail with

	error: $variablename causes a section type conflict

because a section containing const variables is marked read only and so
cannot contain non-const variables.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/ab5500-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ab5500-core.c b/drivers/mfd/ab5500-core.c
index 54d0fe4..3765c76 100644
--- a/drivers/mfd/ab5500-core.c
+++ b/drivers/mfd/ab5500-core.c
@@ -1291,7 +1291,7 @@ struct ab_family_id {
 	char	*name;
 };
 
-static const struct ab_family_id ids[] __initdata = {
+static const struct ab_family_id ids[] __initconst = {
 	/* AB5500 */
 	{
 		.id = AB5500_1_0,
-- 
1.7.9.1

