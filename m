Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab2HCWKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 18:10:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49390 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab2HCWKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 18:10:35 -0400
Date: Fri, 3 Aug 2012 15:10:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Akhilesh Kumar <akhilesh.lxr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Debug ] fs : export debugfs_file_operations symbol
Message-ID: <20120803221031.GA4925@kroah.com>
References: <CADArhcAJzp-t0EaEuqjXP-w85MjPLXTXfhAYtCdue9drtt=HMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADArhcAJzp-t0EaEuqjXP-w85MjPLXTXfhAYtCdue9drtt=HMw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 03:30:44AM +0530, Akhilesh Kumar wrote:
> Hi Hartman
> 
> This patch just exports debugfs_file_operations which improve debugfs
> interface .
> Please review below patch for main line and share your review comments.
> 
> Thanks,
> Akhilesh
> 
> 
> 
> 
> From fd68900cd32f220beee70b55c20b3c74a38d7df8 Mon Sep 17 00:00:00 2001
> From: Akhilesh Kumar <akhilesh.lxr@gmail.com>
> Date: Tue, 31 Jul 2012 17:17:12 +0530
> Subject:[Debug ] fs : export debugfs_file_operations symbol
>  
>  debugfs_file_operations is usefull for file system
>  debugging debugfs_file_operations is not an exported
>  symbol.
> 
> Any kernel module (http://lwn.net/Articles/371208/) using
> 
> debugfs_file_operations will result in build failures
> because of this.
> 
> This patch just exports debugfs_file_operations to fix such problems in
> future
> 
> Signed-off-by: Akhilesh Kumar <akhilesh.lxr@gmail.com>
> ---
>  fs/debugfs/file.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
> index 2340f69..a5150d8 100644
> --- a/fs/debugfs/file.c
> +++ b/fs/debugfs/file.c
> @@ -40,6 +40,7 @@ const struct file_operations debugfs_file_operations = {
>   .open = simple_open,
>   .llseek = noop_llseek,
>  };
> +EXPORT_SYMBOL(debugfs_file_operations);

I fail to understand how this will help you out at all.  You should not
be using this symbol, why would you?

Please show the in-kernel code that needs it, and I will be glad to
reconsider this patch, after it it fixed to use EXPORT_SYMBOL_GPL() as
well, to be consistant with the other debugfs symbols.

greg k-h
