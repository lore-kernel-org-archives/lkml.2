Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1B1Xid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:38:33 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:53375 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753729Ab1B1Xic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:38:32 -0500
Message-ID: <4D6C3205.2040007@lougher.demon.co.uk>
Date: Mon, 28 Feb 2011 23:38:45 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] Squashfs: Update documentation to include compression
 options
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  Documentation/filesystems/squashfs.txt |   28 +++++++++++++++++++---------
  1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/squashfs.txt b/Documentation/filesystems/squashfs.txt
index 66699af..2d78f19 100644
--- a/Documentation/filesystems/squashfs.txt
+++ b/Documentation/filesystems/squashfs.txt
@@ -59,12 +59,15 @@ obtained from this site also.
  3. SQUASHFS FILESYSTEM DESIGN
  -----------------------------

-A squashfs filesystem consists of a maximum of eight parts, packed together on a byte
-alignment:
+A squashfs filesystem consists of a maximum of nine parts, packed together on a
+byte alignment:

  	 ---------------
  	|  superblock 	|
  	|---------------|
+	|  compression  |
+	|    options    |
+	|---------------|
  	|  datablocks   |
  	|  & fragments  |
  	|---------------|
@@ -91,7 +94,14 @@ the source directory, and checked for duplicates.  Once all file data has been
  written the completed inode, directory, fragment, export and uid/gid lookup
  tables are written.

-3.1 Inodes
+3.1 Compression options
+-----------------------
+
+Compressors can optionally support compression specific options (e.g.
+dictionary size).  If non-default compression options have been used, then
+these are stored here.
+
+3.2 Inodes
  ----------

  Metadata (inodes and directories) are compressed in 8Kbyte blocks.  Each
@@ -114,7 +124,7 @@ directory inode are defined: inodes optimised for frequently occurring
  regular files and directories, and extended types where extra
  information has to be stored.

-3.2 Directories
+3.3 Directories
  ---------------

  Like inodes, directories are packed into compressed metadata blocks, stored
@@ -144,7 +154,7 @@ decompressed to do a lookup irrespective of the length of the directory.
  This scheme has the advantage that it doesn't require extra memory overhead
  and doesn't require much extra storage on disk.

-3.3 File data
+3.4 File data
  -------------

  Regular files consist of a sequence of contiguous compressed blocks, and/or a
@@ -163,7 +173,7 @@ Larger files use multiple slots, with 1.75 TiB files using all 8 slots.
  The index cache is designed to be memory efficient, and by default uses
  16 KiB.

-3.4 Fragment lookup table
+3.5 Fragment lookup table
  -------------------------

  Regular files can contain a fragment index which is mapped to a fragment
@@ -173,7 +183,7 @@ A second index table is used to locate these.  This second index table for
  speed of access (and because it is small) is read at mount time and cached
  in memory.

-3.5 Uid/gid lookup table
+3.6 Uid/gid lookup table
  ------------------------

  For space efficiency regular files store uid and gid indexes, which are
@@ -182,7 +192,7 @@ stored compressed into metadata blocks.  A second index table is used to
  locate these.  This second index table for speed of access (and because it
  is small) is read at mount time and cached in memory.

-3.6 Export table
+3.7 Export table
  ----------------

  To enable Squashfs filesystems to be exportable (via NFS etc.) filesystems
@@ -196,7 +206,7 @@ This table is stored compressed into metadata blocks.  A second index table is
  used to locate these.  This second index table for speed of access (and because
  it is small) is read at mount time and cached in memory.

-3.7 Xattr table
+3.8 Xattr table
  ---------------

  The xattr table contains extended attributes for each inode.  The xattrs
-- 
1.7.1

