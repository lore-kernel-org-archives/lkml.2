Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab0H3Pnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 11:43:55 -0400
Received: from s318.xrea.com ([125.53.25.46]:58082 "HELO s318.xrea.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755687Ab0H3Pnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 11:43:53 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Aug 2010 11:43:53 EDT
From: Naohiro Aota <naota@elisp.net>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Naohiro Aota <naota@elisp.net>, Jiri Kosina <jkosina@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 1/2] idr: fix kernel-doc warnings.
Date: Tue, 31 Aug 2010 00:37:03 +0900
Message-ID: <m27hj8cdsw.fsf@elisp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (darwin)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following kernel-doc warnings.

% perl scripts/kernel-doc lib/idr.c > /dev/null
Warning(lib/idr.c:300): No description found for parameter 'starting_id'
Warning(lib/idr.c:300): Excess function parameter 'start_id' description in 'idr_get_new_above'
Warning(lib/idr.c:485): No description found for parameter 'idp'
Warning(lib/idr.c:596): No description found for parameter 'nextidp'
Warning(lib/idr.c:596): Excess function parameter 'id' description in 'idr_get_next'
Warning(lib/idr.c:774): No description found for parameter 'starting_id'
Warning(lib/idr.c:774): Excess function parameter 'staring_id' description in 'ida_get_new_above'
Warning(lib/idr.c:918): No description found for parameter 'ida'

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 lib/idr.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 7f1a4f0..fb86a67 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -284,7 +284,7 @@ static int idr_get_new_above_int(struct idr *idp, void *ptr, int starting_id)
  * idr_get_new_above - allocate new idr entry above or equal to a start id
  * @idp: idr handle
  * @ptr: pointer you want associated with the id
- * @start_id: id to start search at
+ * @starting_id: id to start search at
  * @id: pointer to the allocated handle
  *
  * This is the allocate id function.  It should be called with any
@@ -479,7 +479,7 @@ EXPORT_SYMBOL(idr_remove_all);
 
 /**
  * idr_destroy - release all cached layers within an idr tree
- * idp: idr handle
+ * @idp: idr handle
  */
 void idr_destroy(struct idr *idp)
 {
@@ -586,7 +586,7 @@ EXPORT_SYMBOL(idr_for_each);
 /**
  * idr_get_next - lookup next object of id to given id.
  * @idp: idr handle
- * @id:  pointer to lookup key
+ * @nextidp:  pointer to lookup key
  *
  * Returns pointer to registered object with id, which is next number to
  * given id.
@@ -758,7 +758,7 @@ EXPORT_SYMBOL(ida_pre_get);
 /**
  * ida_get_new_above - allocate new ID above or equal to a start id
  * @ida:	ida handle
- * @staring_id:	id to start search at
+ * @starting_id: id to start search at
  * @p_id:	pointer to the allocated handle
  *
  * Allocate new ID above or equal to @ida.  It should be called with
@@ -912,7 +912,7 @@ EXPORT_SYMBOL(ida_remove);
 
 /**
  * ida_destroy - release all cached layers within an ida tree
- * ida:		ida handle
+ * @ida:		ida handle
  */
 void ida_destroy(struct ida *ida)
 {
-- 
1.7.2

