Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab2C0HUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 03:20:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51549 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab2C0HUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 03:20:13 -0400
Message-ID: <1332832808.9942.5.camel@phoenix>
Subject: [PATCH 3/4] regulator: wm8350: Fix the logic to choose best current
 limit setting
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 27 Mar 2012 15:20:08 +0800
In-Reply-To: <1332832646.9942.1.camel@phoenix>
References: <1332832646.9942.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation in get_isink_val actually choose the biggest current
limit setting falls within the specified range.
What we want is to choose the smallest current limit setting falls within the
specified range. Fix it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8350-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index ff34654..f29803c 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -99,7 +99,7 @@ static int get_isink_val(int min_uA, int max_uA, u16 *setting)
 {
 	int i;
 
-	for (i = ARRAY_SIZE(isink_cur) - 1; i >= 0; i--) {
+	for (i = 0; i < ARRAY_SIZE(isink_cur); i++) {
 		if (min_uA <= isink_cur[i] && max_uA >= isink_cur[i]) {
 			*setting = i;
 			return 0;
-- 
1.7.5.4



