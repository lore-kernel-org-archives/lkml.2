Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab2HRJmL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 05:42:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39086 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab2HRJmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 05:42:08 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 0/4] fat: fix ESTALE errors
Date: Sat, 18 Aug 2012 05:41:39 -0400
Message-Id: <1345282899-7534-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch-set eliminates the client side ESTALE errors when
a FAT partition exported over NFS has its dentries evicted 
from the cache.

One of the reasons for this error is lack of permanent inode 
numbers on FAT which makes it difficult to construct persistent 
file handles.This can be overcome by using the on-disk location
of the directory entries (i_pos) as the inode number.

Once the i_pos is available, it is only a matter of reading the
directory entries from the disk clusters to locate the matching
entry and rebuild the corresponding inode.

Namjae Jeon (4):
  fat: allocate persistent inode numbers
  fat (exportfs): rebuild inode if ilookup() fails
  fat (exportfs): rebuild directory-inode if fat_dget() fails
  Documentation: update nfs option in filesystem/vfat.txt
---
