Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab0KQAQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:16:19 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:59004 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0KQAQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:16:18 -0500
From: "Tim Pepper" <lnxninja@linux.vnet.ibm.com>
Date: Tue, 16 Nov 2010 16:16:12 -0800
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 04/28] fs: change d_delete semantics
Message-ID: <20101117001611.GA22789@tpepper-t61p.dolavim.us>
References: <20101116140900.039761100@kernel.dk>
 <20101116142028.552806605@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116142028.552806605@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 17 Nov at 01:09:04 +1100 npiggin@kernel.dk said:

>  Documentation/filesystems/vfs.txt |   27 +++++++++++++--------------
>  include/linux/dcache.h            |    6 +++---

...minor nit:

There are white space changes in here around d_hash() and d_compare().

> 
> Index: linux-2.6/Documentation/filesystems/vfs.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/filesystems/vfs.txt	2010-11-17 00:50:54.000000000 +1100
> +++ linux-2.6/Documentation/filesystems/vfs.txt	2010-11-17 01:05:50.000000000 +1100
> @@ -841,9 +841,9 @@ the VFS uses a default. As of kernel 2.6
> 
>  struct dentry_operations {
>  	int (*d_revalidate)(struct dentry *, struct nameidata *);
> -	int (*d_hash) (struct dentry *, struct qstr *);
> -	int (*d_compare) (struct dentry *, struct qstr *, struct qstr *);
> -	int (*d_delete)(struct dentry *);
> +	int (*d_hash)(struct dentry *, struct qstr *);
> +	int (*d_compare)(struct dentry *, struct qstr *, struct qstr *);
> +	int (*d_delete)(const struct dentry *);
>  	void (*d_release)(struct dentry *);
>  	void (*d_iput)(struct dentry *, struct inode *);
>  	char *(*d_dname)(struct dentry *, char *, int);

> Index: linux-2.6/include/linux/dcache.h
> ===================================================================
> --- linux-2.6.orig/include/linux/dcache.h	2010-11-17 00:52:04.000000000 +1100
> +++ linux-2.6/include/linux/dcache.h	2010-11-17 01:05:50.000000000 +1100
> @@ -133,9 +133,9 @@ enum dentry_d_lock_class
> 
>  struct dentry_operations {
>  	int (*d_revalidate)(struct dentry *, struct nameidata *);
> -	int (*d_hash) (struct dentry *, struct qstr *);
> -	int (*d_compare) (struct dentry *, struct qstr *, struct qstr *);
> -	int (*d_delete)(struct dentry *);
> +	int (*d_hash)(struct dentry *, struct qstr *);
> +	int (*d_compare)(struct dentry *, struct qstr *, struct qstr *);
> +	int (*d_delete)(const struct dentry *);
>  	void (*d_release)(struct dentry *);
>  	void (*d_iput)(struct dentry *, struct inode *);
>  	char *(*d_dname)(struct dentry *, char *, int);

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
