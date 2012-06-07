Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989Ab2FGEhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:37:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931Ab2FGEUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:20:31 -0400
Message-Id: <20120607040345.911030559@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:41 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Salman Qazi <sqazi@google.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 65/82] ext4: add ext4_mb_unload_buddy in the error path
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salman Qazi <sqazi@google.com>

commit 02b7831019ea4e7994968c84b5826fa8b248ffc8 upstream.

ext4_free_blocks fails to pair an ext4_mb_load_buddy with a matching
ext4_mb_unload_buddy when it fails a memory allocation.

Signed-off-by: Salman Qazi <sqazi@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/mballoc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4636,6 +4636,7 @@ do_more:
 		 */
 		new_entry = kmem_cache_alloc(ext4_free_data_cachep, GFP_NOFS);
 		if (!new_entry) {
+			ext4_mb_unload_buddy(&e4b);
 			err = -ENOMEM;
 			goto error_return;
 		}


