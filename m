Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1IFKgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 06:36:21 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40619 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab1IFKgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 06:36:15 -0400
MIME-Version: 1.0
In-Reply-To: <20110905223734.GB26980@sucs.org>
References: <20110905223734.GB26980@sucs.org>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 6 Sep 2011 11:35:55 +0100
X-Google-Sender-Auth: IriudZD_BDem3GqRumk6_jY_BF0
Message-ID: <CAHkRjk4QXbzzS6_Ks8W_QF14ijQdrXUEN82ifnm8ecxenqYiKA@mail.gmail.com>
Subject: Re: FUSE kmemleak report
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 September 2011 23:37, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> kmemleak is reporting that 32 bytes are being leaked by FUSE:
>
> unreferenced object 0xe373b270 (size 32):
>  comm "fusermount", pid 1207, jiffies 4294707026 (age 2675.187s)
>  hex dump (first 32 bytes):
>    01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  backtrace:
>    [<b05517d7>] kmemleak_alloc+0x27/0x50
>    [<b0196435>] kmem_cache_alloc+0xc5/0x180
>    [<b02455be>] fuse_alloc_forget+0x1e/0x20
>    [<b0245670>] fuse_alloc_inode+0xb0/0xd0
>    [<b01b1a8c>] alloc_inode+0x1c/0x80
>    [<b01b290f>] iget5_locked+0x8f/0x1a0
>    [<b0246022>] fuse_iget+0x72/0x1a0
>    [<b02461da>] fuse_get_root_inode+0x8a/0x90
>    [<b02465cf>] fuse_fill_super+0x3ef/0x590
>    [<b019e56f>] mount_nodev+0x3f/0x90
>    [<b0244e95>] fuse_mount+0x15/0x20
>    [<b019d1bc>] mount_fs+0x1c/0xc0
>    [<b01b5811>] vfs_kern_mount+0x41/0x90
>    [<b01b5af9>] do_kern_mount+0x39/0xd0
>    [<b01b7585>] do_mount+0x2e5/0x660
>    [<b01b7966>] sys_mount+0x66/0xa0
>
> This leak report is consistent and happens once per boot on
> 3.1.0-rc5-dirty.

IIUC, kmemleak reports the fuse_forget_link that corresponds to the
root inode (allocated via fuse_fill_super). The root inode is later
freed (did the mount failed?) but not the forget link. I'm not
familiar with this code, so note exactly sure where the forget link
should have been freed.

-- 
Catalin
