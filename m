Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2JNOlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:41:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46037 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753709Ab2JNOld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:33 -0400
Message-Id: <20121014143535.802536633@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        =?ISO-8859-15?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [ 015/147] UBI: fix autoresize handling in R/O mode
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit abb3e01103eb4e2ea5c15e6fedbc74e08bd4cc2b upstream.

Currently UBI fails in autoresize when it is in R/O mode (e.g., because the
underlying MTD device is R/O). This patch fixes the issue - we just skip
autoresize and print a warning.

Reported-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mtd/ubi/build.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 355756b..8966088 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -799,6 +799,11 @@ static int autoresize(struct ubi_device *ubi, int vol_id)
 	struct ubi_volume *vol = ubi->volumes[vol_id];
 	int err, old_reserved_pebs = vol->reserved_pebs;
 
+	if (ubi->ro_mode) {
+		ubi_warn("skip auto-resize because of R/O mode");
+		return 0;
+	}
+
 	/*
 	 * Clear the auto-resize flag in the volume in-memory copy of the
 	 * volume table, and 'ubi_resize_volume()' will propagate this change


