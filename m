Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab2HZBDL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 21:03:11 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41125 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2HZBDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 21:03:04 -0400
MIME-Version: 1.0
Date: Sun, 26 Aug 2012 09:03:04 +0800
Message-ID: <CAPgLHd8JNf-EbOEZd_Wcrs6NJrLxkVA5wP6PE-qn9Est1mPVxQ@mail.gmail.com>
Subject: [PATCH] Staging: vt6656: using is_broadcast_ether_addr() to simplify
 the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using is_broadcast_ether_addr() to simplify the code.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/vt6656/hostap.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index 682002a..4d0bda5 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -439,9 +439,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 		return -EINVAL;
 	}
 
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
+	if (is_broadcast_ether_addr(param->sta_addr)) {
 		if (param->u.crypt.idx >= MAX_GROUP_KEY)
 			return -EINVAL;
         iNodeIndex = 0;
@@ -663,9 +661,7 @@ static int hostap_get_encryption(PSDevice pDevice,
 
 	param->u.crypt.err = 0;
 
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
+	if (is_broadcast_ether_addr(param->sta_addr)) {
         iNodeIndex = 0;
 	} else {
 	    if (BSSbIsSTAInNodeDB(pDevice, param->sta_addr, &iNodeIndex) == FALSE) {


