Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065Ab2C2VQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:16:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33775 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933918Ab2C2VM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:12:56 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel@pengutronix.de, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 17/17] kstrtox: mark const init data with __initconst instead of __initdata
Date: Thu, 29 Mar 2012 23:12:34 +0200
Message-Id: <1333055554-31300-17-git-send-email-u.kleine-koenig@pengutronix.de>
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
Cc: Alexey Dobriyan <adobriyan@gmail.com>
---
 lib/test-kstrtox.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/test-kstrtox.c b/lib/test-kstrtox.c
index d55769d..bea3f3f 100644
--- a/lib/test-kstrtox.c
+++ b/lib/test-kstrtox.c
@@ -11,7 +11,7 @@ struct test_fail {
 };
 
 #define DEFINE_TEST_FAIL(test)	\
-	const struct test_fail test[] __initdata
+	const struct test_fail test[] __initconst
 
 #define DECLARE_TEST_OK(type, test_type)	\
 	test_type {				\
@@ -21,7 +21,7 @@ struct test_fail {
 	}
 
 #define DEFINE_TEST_OK(type, test)	\
-	const type test[] __initdata
+	const type test[] __initconst
 
 #define TEST_FAIL(fn, type, fmt, test)					\
 {									\
-- 
1.7.9.1

