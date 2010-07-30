Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205Ab0G3R1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:27:30 -0400
Received: from kroah.org ([198.145.64.141]:52107 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758851Ab0G3RT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:56 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:11 2010
Message-Id: <20100730171511.435378447@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>, "Theodore Tso" <tytso@mit.edu>
Subject: [130/165] ext4: Conditionally define compat ioctl numbers
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 899ad0cea6ad7ff4ba24b16318edbc3cbbe03fad upstream (as of v2.6.34-git13)

It is unnecessary, and in general impossible, to define the compat
ioctl numbers except when building the filesystem with CONFIG_COMPAT
defined.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ext4.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -462,6 +462,7 @@ struct ext4_new_group_data {
 #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
 #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
 
+#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
  * ioctl commands in 32 bit emulation
  */
@@ -477,6 +478,7 @@ struct ext4_new_group_data {
 #endif
 #define EXT4_IOC32_GETVERSION_OLD	FS_IOC32_GETVERSION
 #define EXT4_IOC32_SETVERSION_OLD	FS_IOC32_SETVERSION
+#endif
 
 
 /*


