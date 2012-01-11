Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab2AKIEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 03:04:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906Ab2AKIEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 03:04:36 -0500
Date: Wed, 11 Jan 2012 09:03:32 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: akpm@linux-foundation.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH -mm v2] slub: document setting min order with
 debug_guardpage_minorder > 0
Message-ID: <20120111080320.GA2452@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1 -> v2:
- remove trailing whitespace
- note debug_guardpage_minorder is a command line parameter
- make clear that writing to /sys/cache/slab/cache/order will have no
  effect with debug_guardpage_minorder > 0

Acked-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 Documentation/ABI/testing/sysfs-kernel-slab |    4 ++++
 Documentation/vm/slub.txt                   |    5 ++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-slab b/Documentation/ABI/testing/sysfs-kernel-slab
index 8b093f8..91bd6ca 100644
--- a/Documentation/ABI/testing/sysfs-kernel-slab
+++ b/Documentation/ABI/testing/sysfs-kernel-slab
@@ -346,6 +346,10 @@ Description:
 		number of objects per slab.  If a slab cannot be allocated
 		because of fragmentation, SLUB will retry with the minimum order
 		possible depending on its characteristics.
+		When debug_guardpage_minorder=N (N > 0) parameter is specified
+		(see Documentation/kernel-parameters.txt), the minimum possible
+		order is used and this sysfs entry can not be used to change
+		the order at run time.
 
 What:		/sys/kernel/slab/cache/order_fallback
 Date:		April 2008
diff --git a/Documentation/vm/slub.txt b/Documentation/vm/slub.txt
index f464f47..1514d9f 100644
--- a/Documentation/vm/slub.txt
+++ b/Documentation/vm/slub.txt
@@ -131,7 +131,10 @@ slub_min_objects.
 slub_max_order specified the order at which slub_min_objects should no
 longer be checked. This is useful to avoid SLUB trying to generate
 super large order pages to fit slub_min_objects of a slab cache with
-large object sizes into one high order page.
+large object sizes into one high order page. Setting command line
+parameter debug_guardpage_minorder=N (N > 0), forces setting
+slub_max_order to 0, what cause minimum possible order of slabs
+allocation.
 
 SLUB Debug output
 -----------------
-- 
1.7.1

