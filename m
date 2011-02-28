Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab1CATld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:41:33 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52545 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab1CAThV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:21 -0500
Message-Id: <201103011934.p21JYcAL010303@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 28 Feb 2011 15:14:19 -0500
Subject: [PATCH] arch/tile: fix reversed test of strict_strtol() return value
To: linux-kernel@vger.kernel.org
In-Reply-To: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
X-OriginalArrivalTime: 01 Mar 2011 19:34:38.0779 (UTC) FILETIME=[B43438B0:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the "initfree" boot argument.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 9a62479..2ef9ce5 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -1000,7 +1000,7 @@ static long __write_once initfree = 1;
 static int __init set_initfree(char *str)
 {
 	long val;
-	if (strict_strtol(str, 0, &val)) {
+	if (strict_strtol(str, 0, &val) == 0) {
 		initfree = val;
 		pr_info("initfree: %s free init pages\n",
 			initfree ? "will" : "won't");
-- 
1.6.5.2

