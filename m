Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab2DNMJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 08:09:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41740 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab2DNMJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 08:09:54 -0400
Message-ID: <4F896787.4050108@gmail.com>
Date: Sat, 14 Apr 2012 14:03:19 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.28) Gecko/20120306 SUSE/3.1.20 Thunderbird/3.1.20
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hfsplus: Fix bless ioctl when used with hardlinks
References: <1334326014-15244-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1334326014-15244-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/04/2012 16:06, Matthew Garrett ha scritto:
> HFS+ doesn't really implement hard links - instead, hardlinks are indicated
> by a magic file type which refers to an indirect node in a hidden
> directory. The spec indicates that stat() should return the inode number
> of the indirect node, but it turns out that this doesn't satisfy the
> firmware when it's looking for a bootloader - it wants the catalog ID of
> the hardlink file instead. Fix up this case.
>
> Signed-off-by: Matthew Garrett<mjg@redhat.com>
> ---
>   fs/hfsplus/ioctl.c |    9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/hfsplus/ioctl.c b/fs/hfsplus/ioctl.c
> index c640ba5..5ee0681 100644
> --- a/fs/hfsplus/ioctl.c
> +++ b/fs/hfsplus/ioctl.c
> @@ -31,6 +31,7 @@ static int hfsplus_ioctl_bless(struct file *file, int __user *user_flags)
>   	struct hfsplus_sb_info *sbi = HFSPLUS_SB(inode->i_sb);
>   	struct hfsplus_vh *vh = sbi->s_vhdr;
>   	struct hfsplus_vh *bvh = sbi->s_backup_vhdr;
> +	int cnid = (u32)(unsigned long)dentry->d_fsdata;
>

Why a double cast?

Marco
