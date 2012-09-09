Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2IIXbu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:31:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51215 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755770Ab2IIXQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:14 -0400
Message-Id: <20120909224201.973656589@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tony Luck <tony.luck@intel.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [ 83/95] dmi: Feed DMI table to /dev/random driver
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit d114a33387472555188f142ed8e98acdb8181c6d upstream.

Send the entire DMI (SMBIOS) table to the /dev/random driver to
help seed its pools.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/firmware/dmi_scan.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 153980b..b298158 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -6,6 +6,7 @@
 #include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/bootmem.h>
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


