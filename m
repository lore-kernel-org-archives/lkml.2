Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab0DVN3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 09:29:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30769 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab0DVN3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 09:29:14 -0400
Date: Thu, 22 Apr 2010 06:27:49 -0700
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       adilger@sun.com, tytso@mit.edu, mfasheh@suse.com,
       joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       linux-mm@kvack.org, ngupta@vflare.org, jeremy@goop.org,
       JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de,
       dave.mccracken@oracle.com, riel@redhat.com
Subject: Cleancache [PATCH 1/7] (was Transcendent Memory):
	cleancache_poolid in superblock
Message-ID: <20100422132749.GA27287@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4BD04F0E.00E4:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for resend... Mail server DNS problems sending to some recipients)

Cleancache [PATCH 1/7] (was Transcendent Memory): cleancache_poolid in superblock

Add cleancache_poolid to superblock structure... not tied
to CONFIG_CLEANCACHE so as to avoid unnecessary clutter.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Diffstat:
 fs.h                                     |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6.34-rc5/include/linux/fs.h	2010-04-19 17:29:56.000000000 -0600
+++ linux-2.6.34-rc5-cleancache/include/linux/fs.h	2010-04-21 10:06:28.000000000 -0600
@@ -1383,6 +1383,11 @@ struct super_block {
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
