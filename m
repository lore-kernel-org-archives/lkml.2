Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095Ab0JXWKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 18:10:19 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:45122 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933047Ab0JXWKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 18:10:16 -0400
Date: Mon, 25 Oct 2010 00:07:44 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wireless/wl1271: remove redundant if-statement
Message-ID: <20101025000744.17f7086e@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently the return value of wl1271_ps_elp_sleep never gets
checked anyway.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/net/wireless/wl12xx/wl1271_event.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 7b3f503..38ccef7 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -134,8 +134,6 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 
 		/* go to extremely low power mode */
 		wl1271_ps_elp_sleep(wl);
-		if (ret < 0)
-			break;
 		break;
 	case EVENT_EXIT_POWER_SAVE_FAIL:
 		wl1271_debug(DEBUG_PSM, "PSM exit failed");
-- 
1.7.2.2
