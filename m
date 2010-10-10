Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0JJRCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:02:17 -0400
Received: from xenotime.net ([72.52.115.56]:34456 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755797Ab0JJRCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:02:15 -0400
Date: Sun, 10 Oct 2010 10:02:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 16/16] pramfs Makefile and Kconfig
Message-Id: <20101010100211.3c747512.rdunlap@xenotime.net>
In-Reply-To: <4CB1EC2F.7070807@gmail.com>
References: <4CB1EC2F.7070807@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Oct 2010 18:39:11 +0200 Marco Stornelli wrote:

> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> Makefile and Kconfig.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
>  diff -Nurp linux-2.6.36-orig/fs/pramfs/Kconfig linux-2.6.36/fs/pramfs/Kconfig
> --- linux-2.6.36-orig/fs/pramfs/Kconfig	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.36/fs/pramfs/Kconfig	2010-09-14 18:49:52.000000000 +0200
> @@ -0,0 +1,72 @@
> +config PRAMFS
> +	tristate "Persistent and Protected RAM file system support"
> +	depends on HAS_IOMEM && EXPERIMENTAL
> +	select CRC16
> +	help
> +	   If your system has a block of fast (comparable in access speed to
> +	   system memory) and non-volatile RAM and you wish to mount a
> +	   light-weight, full-featured, and space-efficient filesystem over it,
> +	   say Y here, and read <file:Documentation/filesystems/pramfs.txt>.
> +
> +	   To compile this as a module,  choose M here: the module will be
> +	   called pramfs.ko.

	  called pramfs.

(we don't add the .ko suffix; well, we try not to do that)

> +
> +config PRAMFS_XIP
> +	bool "Enable Execute-in-place in PRAMFS"
> +	depends on PRAMFS && !PRAMFS_WRITE_PROTECT
> +	help
> +	   Say Y here to enable xip feature of PRAMFS.

	                        XIP

> +
> +config PRAMFS_WRITE_PROTECT
> +	bool "Enable PRAMFS write protection"
> +	depends on PRAMFS && MMU
> +	default y
> +	help
> +	   Say Y here to enable the write protect feature of PRAMFS.
> +
> +config PRAMFS_XATTR
> +	bool "PRAMFS extended attributes"
> +	depends on PRAMFS
> +	help
> +	  Extended attributes are name:value pairs associated with inodes by
> +	  the kernel or by users (see the attr(5) manual page, or visit
> +	  <http://acl.bestbits.at/> for details).
> +
> +	  If unsure, say N.
> +
> +config PRAMFS_POSIX_ACL
> +	bool "PRAMFS POSIX Access Control Lists"
> +	depends on PRAMFS_XATTR
> +	select FS_POSIX_ACL
> +	help
> +	  Posix Access Control Lists (ACLs) support permissions for users and
> +	  groups beyond the owner/group/world scheme.
> +
> +	  To learn more about Access Control Lists, visit the Posix ACLs for
> +	  Linux website <http://acl.bestbits.at/>.
> +
> +	  If you don't know what Access Control Lists are, say N

end sentence with period ('.').

> +
> +config PRAMFS_SECURITY
> +	bool "PRAMFS Security Labels"
> +	depends on PRAMFS_XATTR
> +	help
> +	  Security labels support alternative access control models
> +	  implemented by security modules like SELinux.  This option
> +	  enables an extended attribute handler for file security
> +	  labels in the pram filesystem.
> +
> +	  If you are not using a security module that requires using
> +	  extended attributes for file security labels, say N.
> +
> +config PRAMFS_TEST
> +	boolean
> +	depends on PRAMFS
> +
> +config TEST_MODULE
> +	tristate "PRAMFS Test"
> +	depends on PRAMFS && m
> +	select PRAMFS_TEST
> +	help
> +	  Say Y here to build a simple module to test the protection of
> +	  PRAMFS. The module will be called pramfs_test.ko.

	                             called pramfs_test.



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
