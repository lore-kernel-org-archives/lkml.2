Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab0KIWuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:50:15 -0500
Received: from kroah.org ([198.145.64.141]:45802 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab0KIWuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:50:13 -0500
Date: Tue, 9 Nov 2010 14:44:50 -0800
From: Greg KH <greg@kroah.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs, sysfs: Change sysfs_pathname function prototype.
Message-ID: <20101109224450.GB21992@kroah.com>
References: <AANLkTikDXtLrfjYkQrkGi44qi0cpp-C+Lxr5j1UkFd2G@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikDXtLrfjYkQrkGi44qi0cpp-C+Lxr5j1UkFd2G@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 05:48:36PM +0600, Rakib Mullick wrote:
> Make sysfs_pathname inline, we we're hit by the following warning:
> 
> 
> fs/sysfs/dir.c:410: warning: ‘sysfs_pathname’ defined but not used
> 
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail>
> ---
> 
> --- linus-36/fs/sysfs/dir.c	2010-10-21 02:30:22.000000000 +0600
> +++ rakib-36/fs/sysfs/dir.c	2010-10-31 17:34:46.000000000 +0600
> @@ -407,7 +407,7 @@ int __sysfs_add_one(struct sysfs_addrm_c
>   *
>   *	XXX: does no error checking on @path size
>   */
> -static char *sysfs_pathname(struct sysfs_dirent *sd, char *path)
> +static inline char *sysfs_pathname(struct sysfs_dirent *sd, char *path)

If it's really not used then why would marking it inline help out any?
Shouldn't we just delete the function instead?

thanks,

greg k-h
