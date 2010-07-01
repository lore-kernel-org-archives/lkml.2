Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0GASYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:24:41 -0400
Received: from kroah.org ([198.145.64.141]:40870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758125Ab0GASYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:34 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:18 2010
Message-Id: <20100701173218.884632345@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Yin Kangkai <kangkai.yin@intel.com>, Jan Kara <jack@suse.cz>,
       Theodore Tso <tytso@mit.edu>
Subject: [patch 143/149] jbd: jbd-debug and jbd2-debug should be writable
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yin Kangkai <kangkai.yin@intel.com>

commit 765f8361902d015c864d5e62019b2f139452d7ef upstream.

jbd-debug and jbd2-debug is currently read-only (S_IRUGO), which is not
correct. Make it writable so that we can start debuging.

Signed-off-by: Yin Kangkai <kangkai.yin@intel.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd/journal.c  |    2 +-
 fs/jbd2/journal.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1913,7 +1913,7 @@ static void __init jbd_create_debugfs_en
 {
 	jbd_debugfs_dir = debugfs_create_dir("jbd", NULL);
 	if (jbd_debugfs_dir)
-		jbd_debug = debugfs_create_u8("jbd-debug", S_IRUGO,
+		jbd_debug = debugfs_create_u8("jbd-debug", S_IRUGO | S_IWUSR,
 					       jbd_debugfs_dir,
 					       &journal_enable_debug);
 }
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2115,7 +2115,8 @@ static void __init jbd2_create_debugfs_e
 {
 	jbd2_debugfs_dir = debugfs_create_dir("jbd2", NULL);
 	if (jbd2_debugfs_dir)
-		jbd2_debug = debugfs_create_u8(JBD2_DEBUG_NAME, S_IRUGO,
+		jbd2_debug = debugfs_create_u8(JBD2_DEBUG_NAME,
+					       S_IRUGO | S_IWUSR,
 					       jbd2_debugfs_dir,
 					       &jbd2_journal_enable_debug);
 }


