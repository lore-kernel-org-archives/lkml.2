Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab0FBSpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 14:45:49 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57875 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392Ab0FBSpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 14:45:47 -0400
Subject: Re: [Linux-ima-user] [PATCH][1/1] fs: wrong type for 'magic'
 argument	in 'simple_fill_super()', fs/libfs.c
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>
In-Reply-To: <201006011906.00880.roberto.sassu@polito.it>
References: <201006011906.00880.roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 14:44:25 -0400
Message-ID: <1275504265.3091.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 19:05 +0200, Roberto Sassu wrote: 
> Description of the issue:
> 
> The function 'simple_fill_super()' in the path 'fs/libfs.c' takes the 'magic' argument as int. 
> In the include file 'include/linux/fs.h' the 's_magic' field of the 'super_block' structure is
> declared as unsigned long.
> This causes a misbehaviour in the 'Integrity Measurement Architecture' security module, 
> since the 's_magic' field is used as criteria to determine if the inode must be measured.

There aren't any magic numbers today greater than 32 bits. Out of
curiosity, which magic number on which platform are you having a
problem?

> This patch applies to the mainline kernel repository.
> 
> 
> >From a9f6d9bc7b2259ac025977f4b28a8b90784caf62 Mon Sep 17 00:00:00 2001
> From: Roberto Sassu <roberto.sassu@polito.it>
> Date: Tue, 1 Jun 2010 18:28:13 +0200
> Subject: [PATCH] BUG: wrong type for magic argument in simple_fill_super(), fs/libfs.c
> 
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>

Reviewed-by: Mimi Zohar <zohar@us.ibm.com>

> ---
>  fs/libfs.c         |    2 +-
>  include/linux/fs.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 09e1016..7d966e8 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -489,7 +489,7 @@ int simple_write_end(struct file *file, struct address_space *mapping,
>   * unique inode values later for this filesystem, then you must take care
>   * to pass it an appropriate max_reserved value to avoid collisions.
>   */
> -int simple_fill_super(struct super_block *s, int magic, struct tree_descr *files)
> +int simple_fill_super(struct super_block *s, unsigned long magic, struct tree_descr *files)
>  {
>   	struct inode *inode;
>         struct dentry *root;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 3428393..471e1ff 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2388,7 +2388,7 @@ extern const struct file_operations simple_dir_operations;
>  extern const struct inode_operations simple_dir_inode_operations;
>  struct tree_descr { char *name; const struct file_operations *ops; int mode; };
>  struct dentry *d_alloc_name(struct dentry *, const char *);
> -extern int simple_fill_super(struct super_block *, int, struct tree_descr *);
> +extern int simple_fill_super(struct super_block *, unsigned long, struct tree_descr *);
>  extern int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
>  extern void simple_release_fs(struct vfsmount **mount, int *count);
> 


