Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab2KUNX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:23:29 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64912 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab2KUNX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:23:28 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v5 0/8] fat: fix estale error on VFAT over NFS.
Date: Wed, 21 Nov 2012 22:23:10 +0900
Message-Id: <1353504190-5766-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch-set eliminates the client side ESTALE errors when a FAT partition
exported over NFS has its dentries evicted from the cache.

One of the reasons for this error is lack of permanent inode numbers on FAT
which makes it difficult to construct persistent file handles.
This can be overcome by using fat_encode_fh() that include i_pos in file handle.

Once the i_pos is available, it is only a matter of reading the directory
entries from the disk clusters to locate the matching entry and rebuild
the corresponding inode.

We reached the conclusion support stable inode's read-only export first after
discussing with OGAWA and Bruce.
And will make it writable with some operation(unlink and rename) limitation
next time.

Namjae Jeon (8)
 fat: modify nfs mount option
 fat: move fat_i_pos_read to fat.h
 fat: pass superblock pointer instead of inode pointer to fat_ent_read()
 fat: introduce a helper fat_get_blknr_offset()
 fat: restructure export_operations
 fat (exportfs): rebuild inode if ilookup() fails
 fat (exportfs): rebuild directory-inode if fat_dget() fails
 Documentation: update nfs option in filesystem/vfat.txt

---
1.7.9.5

