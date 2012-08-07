Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030630Ab2HGWjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:39:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56573 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030612Ab2HGWjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:39:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 065/109] dm thin: reduce endio_hook pool size
Date: Tue,  7 Aug 2012 15:35:24 -0700
Message-Id: <20120807222048.811945757@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alasdair G Kergon <agk@redhat.com>

commit 7768ed33ccdc02801c4483fc5682dc66ace14aea upstream.

Reduce the slab size used for the dm_thin_endio_hook mempool.

Allocation has been seen to fail on machines with smaller amounts
of memory due to fragmentation.

  lvm: page allocation failure. order:5, mode:0xd0
  device-mapper: table: 253:38: thin-pool: Error creating pool's endio_hook mempool

Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -19,7 +19,7 @@
 /*
  * Tunable constants
  */
-#define ENDIO_HOOK_POOL_SIZE 10240
+#define ENDIO_HOOK_POOL_SIZE 1024
 #define DEFERRED_SET_SIZE 64
 #define MAPPING_POOL_SIZE 1024
 #define PRISON_CELLS 1024


