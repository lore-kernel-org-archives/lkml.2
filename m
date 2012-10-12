Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933837Ab2JLMuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 08:50:35 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51333 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab2JLMud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 08:50:33 -0400
MIME-Version: 1.0
In-Reply-To: <20121011221123.8EB8420004E@hpza10.eem.corp.google.com>
References: <20121011221123.8EB8420004E@hpza10.eem.corp.google.com>
Date: Fri, 12 Oct 2012 21:50:31 +0900
Message-ID: <CAKYAXd9ffBiAsE4x1YA0UbpX1SWtEDLiA46bprHfFONLUAW4dQ@mail.gmail.com>
Subject: Re: + fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch added to
 -mm tree
From: Namjae Jeon <linkinjeon@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        a.sahrawat@samsung.com, bfields@fieldses.org,
        hirofumi@mail.parknet.co.jp, namjae.jeon@samsung.com,
        ravi.n1@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am sorry for my mistake.. And Really thanks Andew!.
Have a nice weekend.

2012/10/12  <akpm@linux-foundation.org>:
>
> The patch titled
>      Subject: fat-exportfs-rebuild-inode-if-ilookup-fails-fix
> has been added to the -mm tree.  Its filename is
>      fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: fat-exportfs-rebuild-inode-if-ilookup-fails-fix
>
> fix warnings/types
>
> fs/fat/nfs.c: In function 'fat_nfs_get_inode':
> fs/fat/nfs.c:68: warning: passing argument 3 of 'fat_get_blknr_offset' from incompatible pointer type
> fs/fat/fat.h:218: note: expected 'sector_t *' but argument is of type 'loff_t *'
> fs/fat/inode.c: In function '__fat_write_inode':
> fs/fat/inode.c:630: warning: passing argument 3 of 'fat_get_blknr_offset' from incompatible pointer type
> fs/fat/fat.h:218: note: expected 'sector_t *' but argument is of type 'loff_t *'
>
> Cc: "J. Bruce Fields" <bfields@fieldses.org>
> Cc: Amit Sahrawat <a.sahrawat@samsung.com>
> Cc: Namjae Jeon <namjae.jeon@samsung.com>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> Cc: Ravishankar N <ravi.n1@samsung.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  fs/fat/inode.c |    3 ++-
>  fs/fat/nfs.c   |    2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff -puN fs/fat/inode.c~fat-exportfs-rebuild-inode-if-ilookup-fails-fix fs/fat/inode.c
> --- a/fs/fat/inode.c~fat-exportfs-rebuild-inode-if-ilookup-fails-fix
> +++ a/fs/fat/inode.c
> @@ -616,7 +616,8 @@ static int __fat_write_inode(struct inod
>         struct msdos_sb_info *sbi = MSDOS_SB(sb);
>         struct buffer_head *bh;
>         struct msdos_dir_entry *raw_entry;
> -       loff_t i_pos, blocknr;
> +       loff_t i_pos;
> +       sector_t blocknr;
>         int offset, err;
>
>         if (inode->i_ino == MSDOS_ROOT_INO)
> diff -puN fs/fat/nfs.c~fat-exportfs-rebuild-inode-if-ilookup-fails-fix fs/fat/nfs.c
> --- a/fs/fat/nfs.c~fat-exportfs-rebuild-inode-if-ilookup-fails-fix
> +++ a/fs/fat/nfs.c
> @@ -63,7 +63,7 @@ static struct inode *fat_nfs_get_inode(s
>         if (inode == NULL && MSDOS_SB(sb)->options.nfs == FAT_NFS_NOSTALE_RO) {
>                 struct buffer_head *bh = NULL;
>                 struct msdos_dir_entry *de ;
> -               loff_t blocknr;
> +               sector_t blocknr;
>                 int offset;
>                 fat_get_blknr_offset(MSDOS_SB(sb), i_pos, &blocknr, &offset);
>                 bh = sb_bread(sb, blocknr);
> _
>
> Patches currently in -mm which might be from akpm@linux-foundation.org are
>
> origin.patch
> linux-next.patch
> linux-next-git-rejects.patch
> i-need-old-gcc.patch
> arch-alpha-kernel-systblss-remove-debug-check.patch
> cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
> arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
> arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
> mm.patch
> swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
> drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
> drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
> hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
> fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
> journal_add_journal_head-debug.patch
> kernel-forkc-export-kernel_thread-to-modules.patch
> mutex-subsystem-synchro-test-module-fix.patch
> slab-leaks3-default-y.patch
> put_bh-debug.patch
>
> --
> To unsubscribe from this list: send the line "unsubscribe mm-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
