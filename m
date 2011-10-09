Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1JILMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 07:12:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51577 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab1JILMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 07:12:00 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 4/7] staging: wlags49_h2: Report WPA IE in scan results with IWEVGENIE
Date: Sun,  9 Oct 2011 12:11:34 +0100
Message-Id: <1318158697-15979-5-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318158697-15979-1-git-send-email-kilroyd@googlemail.com>
References: <1318158697-15979-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report the IE using the appropriate event instead of a custom one.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/wl_wext.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_wext.c b/drivers/staging/wlags49_h2/wl_wext.c
index c392fd8..af9fec5 100644
--- a/drivers/staging/wlags49_h2/wl_wext.c
+++ b/drivers/staging/wlags49_h2/wl_wext.c
@@ -2759,21 +2759,19 @@ static int wireless_get_scan(struct net_device *dev, struct iw_request_info *inf
 		buf = iwe_stream_add_point(info, buf, buf_end, &iwe, msg);
 
 
-		/* Custom info (WPA-IE) */
+		/* WPA-IE */
 		wpa_ie = NULL;
 		wpa_ie_len = 0;
 
 		wpa_ie = wl_parse_wpa_ie( probe_resp, &wpa_ie_len );
 		if( wpa_ie != NULL ) {
-			memset( &iwe, 0, sizeof( iwe ));
-			memset( msg, 0, sizeof( msg ));
+			memset(&iwe, 0, sizeof(iwe));
 
-			iwe.cmd = IWEVCUSTOM;
-			sprintf( msg, "wpa_ie=%s", wl_print_wpa_ie( wpa_ie, wpa_ie_len ));
-			iwe.u.data.length = strlen( msg );
+			iwe.cmd = IWEVGENIE;
+			iwe.u.data.length = wpa_ie_len;
 
 			buf = iwe_stream_add_point(info, buf, buf_end,
-						   &iwe, msg);
+						   &iwe, wpa_ie);
 		}
 
 		/* Add other custom info in formatted string format as needed... */
-- 
1.7.4.1

