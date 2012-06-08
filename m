Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761953Ab2FHFZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:25:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43265 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761312Ab2FHFHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:17 -0400
Message-Id: <20120608041846.747688192@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Salman Qazi <sqazi@google.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 44/82] ext4: add ext4_mb_unload_buddy in the error path
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salman Qazi <sqazi@google.com>

commit 02b7831019ea4e7994968c84b5826fa8b248ffc8 upstream.

ext4_free_blocks fails to pair an ext4_mb_load_buddy with a matching
ext4_mb_unload_buddy when it fails a memory allocation.

Signed-off-by: Salman Qazi <sqazi@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/mballoc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4693,6 +4693,7 @@
 		 */
 		new_entry = kmem_cache_alloc(ext4_free_ext_cachep, GFP_NOFS);
 		if (!new_entry) {
+			ext4_mb_unload_buddy(&e4b);
 			err = -ENOMEM;
 			goto error_return;
 		}


