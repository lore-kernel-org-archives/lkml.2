Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab0EJWwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:52:54 -0400
Received: from kroah.org ([198.145.64.141]:33105 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932405Ab0EJWwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:12 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:21 2010
Message-Id: <20100510223321.345147469@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: [046/117] Revert "memory-hotplug: add 0x prefix to HEX block_size_bytes"
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 4dc86ae1f925b2121d4e75058675895f83e54c71 upstream.

This reverts commit ba168fc37dea145deeb8fa9e7e71c748d2e00d74.

It changes user-visible sysfs interfaces, and breaks some existing user
space applications which apparently rely on the fact that the output
does not contain the "0x" prefix.

Requested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -311,7 +311,7 @@ static SYSDEV_ATTR(removable, 0444, show
 static ssize_t
 print_block_size(struct class *class, char *buf)
 {
-	return sprintf(buf, "%#lx\n", (unsigned long)PAGES_PER_SECTION * PAGE_SIZE);
+	return sprintf(buf, "%lx\n", (unsigned long)PAGES_PER_SECTION * PAGE_SIZE);
 }
 
 static CLASS_ATTR(block_size_bytes, 0444, print_block_size, NULL);


