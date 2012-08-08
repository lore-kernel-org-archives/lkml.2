Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab2HHMSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:18:44 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:46464 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010Ab2HHMSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:18:43 -0400
Message-ID: <1344428317.3199.2.camel@phoenix>
Subject: [PATCH 2/7] regulator: wm8350: set_current_limit should select the
 maximum current in specific range
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Wed, 08 Aug 2012 20:18:37 +0800
In-Reply-To: <1344428238.3199.1.camel@phoenix>
References: <1344428238.3199.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8350-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 7f0fa22..1e4f69e 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -99,7 +99,7 @@ static int get_isink_val(int min_uA, int max_uA, u16 *setting)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(isink_cur); i++) {
+	for (i = ARRAY_SIZE(isink_cur) - 1; i >= 0; i--) {
 		if (min_uA <= isink_cur[i] && max_uA >= isink_cur[i]) {
 			*setting = i;
 			return 0;
-- 
1.7.9.5



