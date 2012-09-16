Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab2IPMWH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 08:22:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46740 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2IPMWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 08:22:05 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v3 0/5] fat: make persistent inode numbers and stablize for NFS.
Date: Sun, 16 Sep 2012 08:21:39 -0400
Message-Id: <1347798099-2592-1-git-send-email-linkinjeon@gmail.com>
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

We reached the conclusion support stable inode's read-only export first after
discussing with OGAWA and Bruce.
And will make it writable with some operation(unlink and rename) limitation
next time.

Namjae Jeon (4)
 fat: modify nfs mount option
 fat: allocate persistent inode numbers
 fat (exportfs): rebuild inode if ilookup() fails
 fat (exportfs): rebuild directory-inode if fat_dget() fails
 Documentation: update nfs option in filesystem/vfat.txt

-- 
1.7.9.5

