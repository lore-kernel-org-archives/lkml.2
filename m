Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab2HOTz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:55:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:37437 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab2HOTxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:53:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Tony Luck <tony.luck@intel.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 165/165] dmi: Feed DMI table to /dev/random driver
Date: Wed, 15 Aug 2012 15:48:29 -0400
Message-ID: <1345060109-9187-166-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d114a33387472555188f142ed8e98acdb8181c6d upstream.

Send the entire DMI (SMBIOS) table to the /dev/random driver to
help seed its pools.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/firmware/dmi_scan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index d464672..1816d92 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -5,6 +5,7 @@
 #include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/bootmem.h>
+#include <linux/random.h>
 #include <asm/dmi.h>
 
 /*
@@ -110,6 +111,8 @@ static int __init dmi_walk_early(void (*decode)(const struct dmi_header *,
 
 	dmi_table(buf, dmi_len, dmi_num, decode, NULL);
 
+	add_device_randomness(buf, dmi_len);
+
 	dmi_iounmap(buf, dmi_len);
 	return 0;
 }
-- 
1.7.12.rc2

