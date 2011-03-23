Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab1CWIir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 04:38:47 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42684 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab1CWIik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 04:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=H8XYBPzNsjKbbXLiqTI6KBzzBQalSDxz0MNjZtwOFJarQQw+clNKjuJ2KDPzClfA2f
         ax6Vp2ay+gGGFcnyL4ZmQQZM7f5YsSgqQb+V4vfwulyBqVb4OiNsUynE+M7HIqdZw5NI
         R476oxf6evJXgUZ5jxVG0P0ZgEkb7TQu/5F6M=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1300845590-14184-1-git-send-email-valerie.aurora@gmail.com>
References: <1300845590-14184-1-git-send-email-valerie.aurora@gmail.com>
Date: Wed, 23 Mar 2011 09:38:39 +0100
Message-ID: <AANLkTinnRz2PPc3XqgCK72S9+fqTK0QCUOLkK98S5j_Q@mail.gmail.com>
Subject: Re: [PATCH 00/74] Union mounts version something or other
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Valerie Aurora <valerie.aurora@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        LKML <linux-kernel@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
        hch@lst.de, Miklos Szeredi <miklos@szeredi.hu>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 2:58 AM, Valerie Aurora
<valerie.aurora@gmail.com> wrote:
> Hi union mounts fans(?),
>
> Here's my current union mounts patch set, against 2.6.36-rc5.  I'm
> busy with other things[1] and unlikely to put in significant work on
> union mounts in the next year.  I'm happy to answer questions from
> anyone else working on them.
>
> As always, git trees for the kernel, util-linux, and e2fsprogs, lots
> of documentation, and LWN articles describing the various problems
> unioning file systems will encounter are here:
>
> http://valerieaurora.org/union/
>
> The devkit linked to from that page includes my Usermode Linux testing
> environment, including root file system image.  The README tells you
> how to run the test suite automatically (yes, an automated test suite
> - with Makefile and version control and comments and stuff!).
>
> I took a quick look at the current overlayfs patch set, and it's
> small, clean, and easy to understand.  If it does what people need, I
> say ship it.
>
> Thanks to everyone who reviewed and submitted patches for union mounts!
>
> -VAL
>
> [1] http://adainitiative.org
>
> ---
>
> Felix Fietkau (2):
>  whiteout: jffs2 whiteout support
>  fallthru: jffs2 fallthru support
>
> Jan Blunck (9):
>  VFS: Make lookup_hash() return a struct path
>  autofs4: Save autofs trigger's vfsmount in super block info
>  whiteout/NFSD: Don't return information about whiteouts to userspace
>  whiteout: Add vfs_whiteout() and whiteout inode operation
>  whiteout: Allow removal of a directory with whiteouts
>  whiteout: tmpfs whiteout support
>  union-mount: Introduce MNT_UNION and MS_UNION flags
>  union-mount: Free union stack on removal of topmost dentry from
>    dcache
>  union-mount: Create IS_MNT_UNION()
>
> Valerie Aurora (63):
>  VFS: Comment follow_mount() and friends
>  Documentation: Fix trivial typo in filesystems/sharedsubtree.txt
>  whiteout: Define opaque inode flags and operations
>  ext2: Add ext2_dirent_in_use()
>  ext2: Split ext2_add_entry() from ext2_add_link()
>  whiteout: ext2 whiteout support
>  fallthru: Basic fallthru definitions
>  fallthru: ext2 fallthru support
>  fallthru: tmpfs fallthru support
>  VFS: Add hard read-only users count to superblock
>  VFS: Make clone_mnt()/copy_tree()/collect_mounts() return errors
>  VFS: Add CL_NO_SHARED flag to clone_mnt()/copy_tree()
>  VFS: Add CL_NO_SLAVE flag to clone_mnt()/copy_tree()
>  VFS: Add CL_MAKE_HARD_READONLY flag to clone_mnt()/copy_tree()
>  union-mount: Union mounts documentation
>  union-mount: Add CONFIG_UNION_MOUNT option
>  union-mount: Create union_stack structure
>  union-mount: Add two superblock fields for union mounts
>  union-mount: Add union_alloc()
>  union-mount: Add union_find_dir()
>  union-mount: Create d_free_unions()
>  union-mount: Create union_add_dir()
>  union-mount: Add union_create_topmost_dir()
>  union-mount: Create needs_lookup_union()
>  union-mount: Create check_topmost_union_mnt()
>  union-mount: Add clone_union_tree() and put_union_sb()
>  union-mount: Create build_root_union()
>  union-mount: Create prepare_mnt_union() and cleanup_mnt_union()
>  union-mount: Prevent improper union-related remounts
>  union-mount: Prevent topmost file system from being mounted elsewhere
>  union-mount: Prevent bind mounts of union mounts
>  union-mount: Implement union mount
>  union-mount: Temporarily disable some syscalls
>  union-mount: Basic infrastructure of __lookup_union()
>  union-mount: Process negative dentries in __lookup_union()
>  union-mount: Return files found in lower layers in __lookup_union()
>  union-mount: Build union stack in __lookup_union()
>  union-mount: Follow mount in __lookup_union()
>  union-mount: Add lookup_union()
>  union-mount: Add do_lookup_union() wrapper for __lookup_union()
>  union-mount: Call union lookup functions in lookup path
>  union-mount: Create whiteout on unlink()
>  union-mount: Create whiteout on rmdir()
>  union-mount: Set opaque flag on new directories in unioned file
>    systems
>  union-mount: Copy up directory entries on first readdir()
>  union-mount: Add generic_readdir_fallthru() helper
>  fallthru: ext2 support for lookup of d_type/d_ino in fallthrus
>  fallthru: tmpfs support for lookup of d_type/d_ino in fallthrus
>  fallthru: jffs2 support for lookup of d_type/d_ino in fallthrus
>  VFS: Split inode_permission() and create path_permission()
>  VFS: Create user_path_nd() to lookup both parent and target
>  union-mount: In-kernel file copyup routines
>  union-mount: Implement union-aware access()/faccessat()
>  union-mount: Implement union-aware link()
>  union-mount: Implement union-aware rename()
>  union-mount: Implement union-aware writable open()
>  union-mount: Implement union-aware chown()
>  union-mount: Implement union-aware truncate()
>  union-mount: Implement union-aware chmod()/fchmodat()
>  union-mount: Implement union-aware lchown()
>  union-mount: Implement union-aware utimensat()
>  union-mount: Implement union-aware setxattr()
>  union-mount: Implement union-aware lsetxattr()
>

Shall I cry or laugh? I really don't know...

With your email I remembered my first steps with Linux Live-CD technologies.
As a home-project I created an own sidux live-cd and enlightenment as
window-manager to get a bit familiar with the technolgies/tools behind
it.
Still the mostly used and most effective "technology" in this area is
AUFS in combination with SquashFS compression (see for example Debian
/ GRML / ex-sidux Live-CD frameworks).

But I also remember these "famous words" [1]:

"Note: it becomes clear that "Aufs was rejected. Let's give it up."
According to Christoph Hellwig, linux rejects all union-type filesystems
but UnionMount."

Please hold the line... Please hold the line... Please hold the line???

Whuzzz up with AUFS?
Even there where massive changes to VFS and FS in 2.6.38+, there is an
adapted kernel patch around (for example see Debian's 2.6.38 linux-2.6
packages in experimental branch).

>From my POV OverlayFS is the new star at the skyline and should be
promoted as 1st choice, now.
I am definitely PRO for including it in 2.6.39!
And when looking to the code-size, OverlayFS is small while you send
70+ single patches.

Union-mounts never got out of "technology preview" status and was
stepmotherly promoted in the past.
You are leaving an outdated (unfinished?) code (IIRC I read 2.6.36-rc5
as code-base) and furthermore u-m needs hacked user-space, too.
So, u-m is for me - seen from today and having OverlayFS as an
alternative - a dead horse.
But, BKL-removal showed us... a once started job can be finished :-).

( Sorry, for the rough words. )

I do not want to end this email with some lights at the end of the
tunnel and want to quote Felix [2]:

[...]
> But I'd want Al's ack on the series. And also hear who uses it and how
> it's been tested?
We're using it in OpenWrt (an Embedded Linux distribution) for devices
with tiny amounts of flash for the entire system (e.g. 4 MB).
We're using it to provide a writable on-flash root filesystem with
squashfs for the read-only part and jffs2 for the writable overlay. This
saves some precious flash space compared to using only jffs2, and it
makes it easy for users to reset their device to defaults without having
to reflash.
With a backport of v6 of this series + my fixes that went into v7 this
is working quite well on 2.6.37 and 2.6.38 - I'm using it on a few
wireless access points at home.
[...]

OverlayFS GO GO GO!

- Sedat -

[1] http://aufs.sourceforge.net/
[2] http://lkml.org/lkml/2011/3/22/294
