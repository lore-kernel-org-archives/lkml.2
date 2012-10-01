Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab2JAXCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:02:24 -0400
Received: from 1wt.eu ([62.212.114.60]:35522 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932976Ab2JAXCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:15 -0400
Message-Id: <20121001225205.244757693@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:57 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Theodore Tso <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 180/180] dmi: Feed DMI table to /dev/random driver
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit d114a33387472555188f142ed8e98acdb8181c6d upstream.

Send the entire DMI (SMBIOS) table to the /dev/random driver to
help seed its pools.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/firmware/dmi_scan.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 3a2ccb0..10a4246 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -6,6 +6,7 @@
 #include <linux/efi.h>
 #include <linux/bootmem.h>
 #include <linux/slab.h>
+#include <linux/random.h>
 #include <asm/dmi.h>
 
 /*
@@ -111,6 +112,8 @@ static int __init dmi_walk_early(void (*decode)(const struct dmi_header *,
 
 	dmi_table(buf, dmi_len, dmi_num, decode, NULL);
 
+	add_device_randomness(buf, dmi_len);
+
 	dmi_iounmap(buf, dmi_len);
 	return 0;
 }
-- 
1.7.2.1.45.g54fbc



