Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab0JKAa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 20:30:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54781 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab0JKAa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 20:30:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=pNFbgsF6Uo/xkzE2qImcT2ijTs1pM3t3uqvj8yA8A1NypvlSOGk4e8/lMBOZ0FlI5k
         9YHbG0g1x5MpEiS4fa+98YqxaFxg9JnfaW9kCQ5kAgwhHlYYafCf28sJ8XUTLIs/HI/I
         szQjXymm2IuKNaeFkTvfq29v8IUWG58tn8MnA=
MIME-Version: 1.0
Date: Mon, 11 Oct 2010 03:30:25 +0300
Message-ID: <AANLkTin8mAaHz_PypS9j4vQ35WozgD==U493e3OW_sy2@mail.gmail.com>
Subject: Horrible btrfs performance on cold cache
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I use btrfs on most of my volumes on my laptop, and I've always felt
booting was very slow, but definitely sure is slow, is starting up
Google Chrome:

encrypted ext4: ~20s
btrfs: ~2:11s

I have tried different things to find out exactly what is the issue,
but haven't quite found it yet.

Here's some stuff I got from latencytop, not sure if would be helpful:

4969.1ms
sys_mmap_pgoff
syscall_call
(chrome)

1139.9ms
sync_page
sync_page_killable
__lock_page_killable
generic_file_aio_read
do_sync_read
vfs_read
sys_read
sysenter_do_call
(chrome)

431.9ms
sync_page
wait_on_page_bit
read_extent_buffer_pages
btree_read_extent_buffer_pages
read_tree_block
read_block_for_search
btrfs_search_slot
lookup_inline_extent_backref
__btrfs_free_extent
run_clustered_refs
btrfs_run_delayed_refs
btrfs_commit_transaction
(btrfs)

Cheers.

-- 
Felipe Contreras
