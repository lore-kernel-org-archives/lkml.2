Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab0LBEGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 23:06:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40588 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757059Ab0LBEG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 23:06:28 -0500
Date: Wed, 1 Dec 2010 19:59:06 -0800
From: Greg KH <gregkh@suse.de>
To: Cong Wang <amwang@redhat.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [Patch] debugfs: remove module_exit()
Message-ID: <20101202035906.GA10006@suse.de>
References: <20101109092449.6284.90481.sendpatchset@localhost.localdomain>
 <20101201013547.GA19390@kroah.com>
 <4CF5EC28.6060402@redhat.com>
 <20101201155635.GA29078@suse.de>
 <4CF70FCE.7060606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF70FCE.7060606@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 11:17:34AM +0800, Cong Wang wrote:
> On 12/01/10 23:56, Greg KH wrote:
> >On Wed, Dec 01, 2010 at 02:33:12PM +0800, Cong Wang wrote:
> >>On 12/01/10 09:35, Greg KH wrote:
> >>>On Tue, Nov 09, 2010 at 04:19:58AM -0500, Amerigo Wang wrote:
> >>>>debugfs can't be a module, so module_exit() is meaningless
> >>>>for it.
> >>>>
> >>>>Signed-off-by: WANG Cong<amwang@redhat.com>
> >>>>
> >>>>---
> >>>>diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
> >>>>index 37a8ca7..d38c88f 100644
> >>>>--- a/fs/debugfs/inode.c
> >>>>+++ b/fs/debugfs/inode.c
> >>>>@@ -13,9 +13,6 @@
> >>>>   *
> >>>>   */
> >>>>
> >>>>-/* uncomment to get debug messages from the debug filesystem, ah the irony. */
> >>>>-/* #define DEBUG */
> >>>
> >>>Why did you remove these lines?  They don't pertain to this patch.
> >>
> >>These lines are obsolete.
> >
> >Even if they were (and hint, I don't think they are), they have nothing
> >to do with the patch you created so they don't belong here.  The rule is
> >"one patch per logical change" and you didn't even describe that you
> >were removing these lines in the changelog entry, so that's two strikes
> >against removing these lines.
> >
> 
> Ok, teach me where DEBUG is used in that file?

It is.  And even if it isn't, it still shouldn't be done in this patch,
which is my main point here.

> >>>>-
> >>>>  #include<linux/module.h>
> >>>>  #include<linux/fs.h>
> >>>>  #include<linux/mount.h>
> >>>>@@ -540,17 +537,5 @@ static int __init debugfs_init(void)
> >>>>
> >>>>  	return retval;
> >>>>  }
> >>>>-
> >>>>-static void __exit debugfs_exit(void)
> >>>>-{
> >>>>-	debugfs_registered = false;
> >>>>-
> >>>>-	simple_release_fs(&debugfs_mount,&debugfs_mount_count);
> >>>>-	unregister_filesystem(&debug_fs_type);
> >>>>-	kobject_put(debug_kobj);
> >>>>-}
> >>>
> >>>When the code is built into the kernel, the __exit function should go
> >>>away, so this isn't costing us any extra memory, right?
> >>
> >>
> >>Perhaps, but this can still reduce the vmlinux size, right?
> >
> >Which really doesn't matter, right?  How much is it reduced?
> >
> >>>And debugfs used to be able to be built as a module, perhaps it will be
> >>>in the future?  I don't think this patch is really needed.
> >>>
> >>
> >>Huh? Wasn't it a module before?
> >
> >Yes it was.
> >
> >>I think the problem is tracers use debugfs, it needs to depends on DEBUGFS=y.
> >
> >So if you disable tracing, then you could use debugfs as a module,
> >right?  So the patch should not be applied.
> >
> 
> No, that CONFIG is a bool, no way to make it as a module.
> Since you insist, I will send a patch to make it as a module.

{sigh}  No, that's not what I ment at all.

greg k-h
