Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761025Ab0J2J5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 05:57:51 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56525 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab0J2J5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 05:57:48 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org
Subject: [PATCH -V22 00/14] Generic name to handle and open by handle syscalls
Date: Fri, 29 Oct 2010 15:27:09 +0530
Message-Id: <1288346243-12211-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The below set of patches implement open by handle support using exportfs
operations. This allows user space application to map a file name to file
handle and later open the file using handle. This should be usable
for userspace NFS [1] and 9P server [2]. XFS already support this with the ioctls
XFS_IOC_PATH_TO_HANDLE and XFS_IOC_OPEN_BY_HANDLE.

[1] http://nfs-ganesha.sourceforge.net/
[2] http://thread.gmane.org/gmane.comp.emulators.qemu/68992

git repo for the patchset at:
git://git.kernel.org/pub/scm/linux/kernel/git/kvaneesh/linux-open-handle.git open-by-handle

Test case can be found at
http://git.kernel.org/?p=fs/ext2/kvaneesh/handle-test.git
git://git.kernel.org/pub/scm/fs/ext2/kvaneesh/handle-test.git

Changes from V21:
a) move inode->i_nlink == 0 check from file system link callback to VFS

-aneesh

