Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab2K1Chs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 21:37:48 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:49551 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751645Ab2K1Chq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 21:37:46 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 2/3] staging/fwserial: Use WARN_ONCE when port table is corrupted
Date: Tue, 27 Nov 2012 21:37:12 -0500
Message-Id: <1354070233-4838-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354070233-4838-1-git-send-email-peter@hurleysoftware.com>
References: <20121127170407.GC2687@kroah.com>
 <1354070233-4838-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 99a2d2d..0681967 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -939,14 +939,9 @@ static void fwserial_destroy(struct kref *kref)
 
 	mutex_lock(&port_table_lock);
 	for (j = 0; j < num_ports; ++i, ++j) {
-		static bool once;
-		int corrupt = port_table[i] != ports[j];
-		if (corrupt && !once) {
-			WARN(corrupt, "port_table[%d]: %p != ports[%d]: %p",
-			     i, port_table[i], j, ports[j]);
-			once = true;
-			port_table_corrupt = true;
-		}
+		port_table_corrupt |= port_table[i] != ports[j];
+		WARN_ONCE(port_table_corrupt, "port_table[%d]: %p != ports[%d]: %p",
+		     i, port_table[i], j, ports[j]);
 
 		port_table[i] = NULL;
 	}
-- 
1.8.0

