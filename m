Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab2JDVye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:54:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56720 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933955Ab2JDVW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:22:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: =?UTF-8?q?=5B=2044/58=5D=20UBI=3A=20fix=20autoresize=20handling=20in=20R/O=20mode?=
Date: Thu,  4 Oct 2012 14:19:51 -0700
Message-Id: <20121004210641.015111922@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.449598766@linuxfoundation.org>
References: <20121004210635.449598766@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit abb3e01103eb4e2ea5c15e6fedbc74e08bd4cc2b upstream.

Currently UBI fails in autoresize when it is in R/O mode (e.g., because the
underlying MTD device is R/O). This patch fixes the issue - we just skip
autoresize and print a warning.

Reported-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/ubi/build.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -759,6 +759,11 @@ static int autoresize(struct ubi_device
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


