Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab1HUOE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 10:04:28 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:51373 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab1HUOEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 10:04:23 -0400
X-Greylist: delayed 733 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Aug 2011 10:04:21 EDT
Date: Sun, 21 Aug 2011 15:52:42 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, ian.campbell@citrix.com, vgoyal@redhat.com,
        horms@verge.net.au, olaf@aepfle.de, kexec@lists.infradead.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] kexec: Export compare_ranges() function from firmware_memmap.c module
Message-ID: <20110821135242.GC17323@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export compare_ranges() function from firmware_memmap.c module.
It is generic function and it could be used by other modules.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 kexec/firmware_memmap.c |   14 ++------------
 kexec/firmware_memmap.h |   13 +++++++++++++
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/kexec/firmware_memmap.c b/kexec/firmware_memmap.c
index d8afed5..9598933 100644
--- a/kexec/firmware_memmap.c
+++ b/kexec/firmware_memmap.c
@@ -179,18 +179,8 @@ static int parse_memmap_entry(const char *entry, struct memory_range *range)
 	return 0;
 }
 
-/**
- * Compares two memory ranges according to their start address. This function
- * can be used with qsort() as @c compar function.
- *
- * @param[in] first a pointer to the first memory range
- * @param[in] second a pointer to the second memory range
- * @return 0 if @p first and @p second have the same start address,
- *         a value less then 0 if the start address of @p first is less than
- *         the start address of @p second, and a value greater than 0 if
- *         the opposite is in case.
- */
-static int compare_ranges(const void *first, const void *second)
+/* documentation: firmware_memmap.h */
+int compare_ranges(const void *first, const void *second)
 {
 	const struct memory_range *first_range = first;
 	const struct memory_range *second_range = second;
diff --git a/kexec/firmware_memmap.h b/kexec/firmware_memmap.h
index adb03c3..eac0ddb 100644
--- a/kexec/firmware_memmap.h
+++ b/kexec/firmware_memmap.h
@@ -39,6 +39,19 @@
  */
 
 /**
+ * Compares two memory ranges according to their start address. This function
+ * can be used with qsort() as @c compar function.
+ *
+ * @param[in] first a pointer to the first memory range
+ * @param[in] second a pointer to the second memory range
+ * @return 0 if @p first and @p second have the same start address,
+ *         a value less then 0 if the start address of @p first is less than
+ *         the start address of @p second, and a value greater than 0 if
+ *         the opposite is in case.
+ */
+int compare_ranges(const void *first, const void *second);
+
+/**
  * Checks if the kernel provides the /sys/firmware/memmap interface.
  * It makes sense to use that function in advance before calling
  * get_firmware_memmap_ranges() because the latter function prints an error
-- 
1.5.6.5
