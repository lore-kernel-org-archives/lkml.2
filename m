Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab0HCAEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 20:04:45 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57925 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab0HCAEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 20:04:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OFPR8aiTP5bmzctbSOSx6U4aTfZhcC/RsIUrtn02Hqzf28XEDoH4wK9mI+3TTWIRy3
         RFig3abXNbZp5gVjUtzcoE/hYqVyJT06f+b/Joz4FAPlkKx9fbdXzlCrJEtiEFKWF8yn
         ZEffqCoNdMkhi49c3xWzCOIe58Z4Vtbi3pS/8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, j@w1.fi,
        linville@tuxdriver.com, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]hostap:hostap_ioctl.c Fix variable 'hostscan' set but not used 
Date: Mon,  2 Aug 2010 17:04:39 -0700
Message-Id: <1280793879-1768-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below fixes a compiler warning:
  CC [M]  drivers/net/wireless/hostap/hostap_ioctl.o
drivers/net/wireless/hostap/hostap_ioctl.c: In function 'prism2_translate_scan':
drivers/net/wireless/hostap/hostap_ioctl.c:1954:13: warning: variable 'hostscan' set but not used

Keep in mind I've looked and searched for a fix for this but
couldnt come up with anything.(if there is let me know and I'll have a try at it). 

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wireless/hostap/hostap_ioctl.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index 27d462f..25420e3 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -1951,7 +1951,7 @@ static inline int prism2_translate_scan(local_info_t *local,
 					char *buffer, int buflen)
 {
 	struct hfa384x_hostscan_result *scan;
-	int entry, hostscan;
+	int entry;
 	char *current_ev = buffer;
 	char *end_buf = buffer + buflen;
 	struct list_head *ptr;
@@ -1964,7 +1964,6 @@ static inline int prism2_translate_scan(local_info_t *local,
 		bss->included = 0;
 	}
 
-	hostscan = local->last_scan_type == PRISM2_HOSTSCAN;
 	for (entry = 0; entry < local->last_scan_results_count; entry++) {
 		int found = 0;
 		scan = &local->last_scan_results[entry];
-- 
1.7.1.rc1.21.gf3bd6

