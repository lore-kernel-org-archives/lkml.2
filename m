Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1BFQop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 11:44:45 -0500
Received: from xenotime.net ([72.52.115.56]:40015 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752932Ab1BFQoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 11:44:44 -0500
Date: Sun, 6 Feb 2011 08:44:40 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Kconfig: XIP doesn't depend on block
Message-Id: <20110206084440.a6c2df3b.rdunlap@xenotime.net>
In-Reply-To: <4D4EBAF4.9070403@gmail.com>
References: <4D4EBAF4.9070403@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Feb 2011 16:15:00 +0100 Marco Stornelli wrote:

> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> XIP doesn't depend on block symbol, then we can reorder the Kconfig.
> For ext2 doesn't change the Kconfig behavior but if other fs will use
> FS_XIP it won't need to include block support if not needed.

Hi Marco,

Do you know of a filesystem where this matters?

> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
> 
> --- Kconfig.orig	2011-01-19 00:14:02.000000000 +0100
> +++ Kconfig	2011-02-06 16:04:51.000000000 +0100

This filename should include path, like
--- fs/Kconfig.orig
+++ fs/Kconfig

> @@ -9,13 +9,6 @@ if BLOCK
>  source "fs/ext2/Kconfig"
>  source "fs/ext3/Kconfig"
>  source "fs/ext4/Kconfig"
> -

The 3 filesystems above are immediately under:

if BLOCK

so ext[234] depend on BLOCK.  Why would it matter about FS_XIP?

I don't object to the patch if FS_XIP builds/works without BLOCK being
enabled.


> -config FS_XIP
> -# execute in place
> -	bool
> -	depends on EXT2_FS_XIP
> -	default y
> -
>  source "fs/jbd/Kconfig"
>  source "fs/jbd2/Kconfig"
>  
> @@ -38,6 +31,12 @@ source "fs/nilfs2/Kconfig"
>  
>  endif # BLOCK
>  
> +config FS_XIP
> +# execute in place
> +	bool
> +	depends on EXT2_FS_XIP
> +	default y
> +
>  # Posix ACL utility routines
>  #
>  # Note: Posix ACLs can be implemented without these helpers.  Never use
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
