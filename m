Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab0JEKWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:22:37 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:58582 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab0JEKWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:22:34 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org
Subject: [PATCH -V21 00/12] Generic name to handle and open by handle syscalls
Date: Tue,  5 Oct 2010 15:52:08 +0530
Message-Id: <1286274140-26533-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
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

Changes from V20:
a) Use better variable names
b) change handle_size type to __u32
c) max handle size is now nfsv4 handle size. Considering file system would
   want to support a handle that can fit into nfsv4 handle size limiting
   max handle size to 128 rather than 4096 is the right thing.
d) I didn't add Ceph changes in the series. I am expecting the changes
   will go via Ceph tree.

-aneesh

