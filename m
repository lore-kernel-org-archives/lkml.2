Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1A2TIf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 14:08:35 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:46731 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab1A2TIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 14:08:34 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org
Subject: [PATCH -V26 00/16] Generic name to handle and open by handle syscalls
Date: Sun, 30 Jan 2011 00:38:03 +0530
Message-Id: <1296328099-23263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

Changes from V22:
a) Add support for O_PATH open flag
b) Add support "" names in *at syscalls
c) Add support O_PATH descriptor in few selective syscalls like stat, chown,
   chmod and dup

NOTE: v23-25 can be found in the git repo

-aneesh

