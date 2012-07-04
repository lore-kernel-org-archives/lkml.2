Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2GDIqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:46:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:7380 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab2GDIqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:46:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="173277829"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, proski@gnu.org,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        joe@perches.com, Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv3 1/3] lib: printf: update documentation to cover all of %p[Mm][FR]
Date: Wed,  4 Jul 2012 11:45:50 +0300
Message-Id: <1341391552-4842-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341341280.2012.3.camel@joe2Laptop>
References: <1341341280.2012.3.camel@joe2Laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 Documentation/printk-formats.txt |    1 +
 lib/vsprintf.c                   |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index d8d168fa..90ff4d7 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -59,6 +59,7 @@ MAC/FDDI addresses:
 	%pMR	05:04:03:02:01:00
 	%pMF	00-01-02-03-04-05
 	%pm	000102030405
+	%pmR	050403020100
 
 	For printing 6-byte MAC/FDDI addresses in hex notation. The 'M' and 'm'
 	specifiers result in a printed address with ('M') or without ('m') byte
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index a0b5f15..e500158 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -946,7 +946,7 @@ int kptr_restrict __read_mostly;
  * - 'm' For a 6-byte MAC address, it prints the hex address without colons
  * - 'MF' For a 6-byte MAC FDDI address, it prints the address
  *       with a dash-separated hex notation
- * - '[mM]R For a 6-byte MAC address, Reverse order (Bluetooth)
+ * - '[mM]R' For a 6-byte MAC address, Reverse order (Bluetooth)
  * - 'I' [46] for IPv4/IPv6 addresses printed in the usual way
  *       IPv4 uses dot-separated decimal without leading 0's (1.2.3.4)
  *       IPv6 uses colon separated network-order 16 bit hex with leading 0's
@@ -1287,7 +1287,10 @@ qualifier:
  * %pR output the address range in a struct resource with decoded flags
  * %pr output the address range in a struct resource with raw flags
  * %pM output a 6-byte MAC address with colons
+ * %pMR output a 6-byte MAC address with colons in reversed order
+ * %pMF output a 6-byte MAC address with dashes
  * %pm output a 6-byte MAC address without colons
+ * %pmR output a 6-byte MAC address without colons in reversed order
  * %pI4 print an IPv4 address without leading zeros
  * %pi4 print an IPv4 address with leading zeros
  * %pI6 print an IPv6 address with colons
-- 
1.7.10

