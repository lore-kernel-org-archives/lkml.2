Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab0KFP4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 11:56:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54492 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab0KFP4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 11:56:48 -0400
Date: Sat, 6 Nov 2010 08:48:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 16/16 v2] pramfs: Makefile and Kconfig
Message-Id: <20101106084836.b9ba01f6.randy.dunlap@oracle.com>
In-Reply-To: <4CD51969.3060603@gmail.com>
References: <4CD51969.3060603@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Nov 2010 10:01:29 +0100 Marco Stornelli wrote:

> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> Makefile and Kconfig.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
> +config TEST_MODULE
> +	tristate "PRAMFS Test"
> +	depends on PRAMFS && m
> +	select PRAMFS_TEST
> +	help
> +	  Say Y here to build a simple module to test the protection of
> +	  PRAMFS. The module will be called pramfs_test.

Since kconfig symbols are global, this one needs something like
PRAMFS_ as a prefix, please.


> diff -Nurp linux-2.6.36-orig/fs/pramfs/Makefile linux-2.6.36/fs/pramfs/Makefile
> --- linux-2.6.36-orig/fs/pramfs/Makefile	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.36/fs/pramfs/Makefile	2010-09-14 18:49:52.000000000 +0200
> @@ -0,0 +1,14 @@
> +#
> +# Makefile for the linux pram-filesystem routines.
> +#
> +
> +obj-$(CONFIG_PRAMFS) += pramfs.o
> +obj-$(CONFIG_TEST_MODULE) += pramfs_test.o
> +
> +pramfs-y := balloc.o dir.o file.o inode.o namei.o super.o symlink.o
> +
> +pramfs-$(CONFIG_PRAMFS_WRITE_PROTECT) += wprotect.o
> +pramfs-$(CONFIG_PRAMFS_XIP) += xip.o
> +pramfs-$(CONFIG_PRAMFS_XATTR) += xattr.o xattr_user.o xattr_trusted.o desctree.o
> +pramfs-$(CONFIG_PRAMFS_POSIX_ACL) += acl.o
> +pramfs-$(CONFIG_PRAMFS_SECURITY) += xattr_security.o


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
