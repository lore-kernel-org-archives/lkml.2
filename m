Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab2IDP5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:57:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56393 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab2IDP5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:57:37 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org,
        bfields@fieldses.org, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v2 0/5] fat: make persistent inode numbers and stablize for NFS.
Date: Wed,  5 Sep 2012 00:57:08 +0900
Message-Id: <1346774228-7993-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch-set eliminates the client side ESTALE errors when a FAT partition
exported over NFS has its dentries evicted from the cache.

One of the reasons for this error is lack of permanent inode numbers on FAT
which makes it difficult to construct persistent file handles.
This can be overcome by using the on-disk location of the directory entries
(i_pos) as the inode numbers.

Once the i_pos is available, it is only a matter of reading the directory
entries from the disk clusters to locate the matching entry and rebuild
the corresponding inode.

If process is referring to the file, and the file is unlinked(deleted).
Then, the file 'i_pos' is added to the busy list so the the entry is not
available for new file creation. when finally inode is evicted
the corresponding busy list entries are removed and slots are made
available for new entries.

Namjae Jeon (5)
 fat: allocate persistent inode numbers
 fat (exportfs): rebuild inode if ilookup() fails
 fat (exportfs): rebuild directory-inode if fat_dget() fails
 fat: eliminate-orphaned-inode-number-allocation
 Documentation: update nfs option in filesystem/vfat.txt

-- 
1.7.9.5

