Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab1IEWhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 18:37:40 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:36105 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1IEWhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 18:37:36 -0400
Date: Mon, 5 Sep 2011 23:37:34 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: FUSE kmemleak report
Message-ID: <20110905223734.GB26980@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

kmemleak is reporting that 32 bytes are being leaked by FUSE:

unreferenced object 0xe373b270 (size 32):
  comm "fusermount", pid 1207, jiffies 4294707026 (age 2675.187s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<b05517d7>] kmemleak_alloc+0x27/0x50
    [<b0196435>] kmem_cache_alloc+0xc5/0x180
    [<b02455be>] fuse_alloc_forget+0x1e/0x20
    [<b0245670>] fuse_alloc_inode+0xb0/0xd0
    [<b01b1a8c>] alloc_inode+0x1c/0x80
    [<b01b290f>] iget5_locked+0x8f/0x1a0
    [<b0246022>] fuse_iget+0x72/0x1a0
    [<b02461da>] fuse_get_root_inode+0x8a/0x90
    [<b02465cf>] fuse_fill_super+0x3ef/0x590
    [<b019e56f>] mount_nodev+0x3f/0x90
    [<b0244e95>] fuse_mount+0x15/0x20
    [<b019d1bc>] mount_fs+0x1c/0xc0
    [<b01b5811>] vfs_kern_mount+0x41/0x90
    [<b01b5af9>] do_kern_mount+0x39/0xd0
    [<b01b7585>] do_mount+0x2e5/0x660
    [<b01b7966>] sys_mount+0x66/0xa0

This leak report is consistent and happens once per boot on
3.1.0-rc5-dirty.

-- 
Sitsofe | http://sucs.org/~sits/
