Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab0H3WdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 18:33:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55589 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab0H3WdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 18:33:13 -0400
Date: Mon, 30 Aug 2010 15:31:03 -0700
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        adilger@sun.com, tytso@mit.edu, mfasheh@suse.com,
        joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-mm@kvack.org, ngupta@vflare.org, jeremy@goop.org,
        JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@kernel.dk,
        dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com, mel@csn.ul.ie,
        yinghan@google.com, gthelen@google.com
Subject: [PATCH V4 2/8] Cleancache: cleancache_poolid in superblock
Message-ID: <20100830223103.GA1247@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH V4 2/8] Cleancache: cleancache_poolid in superblock

Add cleancache_poolid to superblock structure... not tied
to CONFIG_CLEANCACHE so as to avoid unnecessary clutter.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Diffstat:
 fs.h                                     |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6.36-rc3/include/linux/fs.h	2010-08-29 09:36:04.000000000 -0600
+++ linux-2.6.36-rc3-cleancache/include/linux/fs.h	2010-08-30 09:20:43.000000000 -0600
@@ -1381,6 +1381,11 @@ struct super_block {
 	 * generic_show_options()
 	 */
 	char *s_options;
+
+	/*
+	 * Saved pool identifier for cleancache (-1 means none)
+	 */
+	int cleancache_poolid;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
