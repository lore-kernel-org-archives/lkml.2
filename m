Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab0EQTZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:25:52 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:50865 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754905Ab0EQTZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:25:50 -0400
Message-ID: <4BF197B5.60004@lougher.demon.co.uk>
Date: Mon, 17 May 2010 20:23:33 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] Squashfs: add xattr file system support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches add xattr file system support to Squashfs.

Xattr layout highlights

1. Layout can store up to 2^48 bytes of compressed xattr data.
2. Number of xattrs per inode unlimited.
3. Total size of xattr data per inode 2^48 bytes of compressed data.
4. Up to 4 Gbytes of data per xattr value.
5. Inline and out-of-line xattr values supported for higher performance
     in xattr scanning (listxattr & getxattr), and to allow xattr value
     de-duplication.
6. Both whole inode xattr duplicate detection and individual xattr value
     duplicate detection supported.  These can obviously nest, file C's
     xattrs can be a complete duplicate of file B, and file B's xattrs
     can be a partial duplicate of file A.
7. Xattr name prefix types stored, allowing the redundant "user.", "trusted."
     etc. characters to be eliminated and more concisely stored.
8. Support for files, directories, symbolic links, device nodes, fifos and sockets.


Xattr support for mksquashfs is in Squashfs CVS here

http://sourceforge.net/projects/squashfs/develop

These patches are also in git, here

git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-xattr.git master

gitweb http://git.kernel.org/?p=linux/kernel/git/pkl/squashfs-xattr.git;a=summary


Phillip
