Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab1K3Uz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 15:55:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab1K3Uz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 15:55:56 -0500
Date: Wed, 30 Nov 2011 12:55:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: yanhong <tempname2@hotmail.com>
Cc: <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] init/do_mounts.c : Create /root if it does not exits
Message-Id: <20111130125555.85ac54e7.akpm@linux-foundation.org>
In-Reply-To: <COL118-W62A0038F6E85B96D4881F6F6CC0@phx.gbl>
References: <COL118-W62A0038F6E85B96D4881F6F6CC0@phx.gbl>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Nov 2011 08:34:18 +0000
yanhong <tempname2@hotmail.com> wrote:

> 
> From: YanHong <tempname2@hotmail.com>
> 
> If someone supplies an initramfs without /root in it, and we fail to execute rdinit, we will try to mount root device and fail, for the mount point does not exits. 
> 
> But we get error message "VFS: Cannot open root device". It's confusing. 
> 
> We can give more detailed error message, or we can go further: if /root does not exits,  create one.
> 

I really don't know enough about initramfs usage to know if this is a
good or bad thing.  Can anyone else comment?

> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -350,6 +350,9 @@ void __init mount_block_root(char *name, int flags)
>         const char *b = name;
>  #endif
> 
> +       if (sys_access((const char __user *) "/root", 0) != 0)
> +               sys_mkdir((const char __user *) "/root", 0700);
> +
>         get_fs_names(fs_names);
>  retry:
>         for (p = fs_names; *p; p += strlen(p)+1) {

I suppose we could remove the sys_access() check and just run mkdir(),
which will fail to do anything if /root already exists.
