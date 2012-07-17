Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab2GQTkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:40:08 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56740 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab2GQTkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:40:05 -0400
Date: Tue, 17 Jul 2012 14:39:51 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: =?utf-8?Q?Martin-=C3=89ric?= Racine <martin-eric.racine@iki.fi>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: [PATCH] scripts/package/builddeb: upgrade to current practices
Message-ID: <20120717193951.GA15208@burratino>
References: <1342547874.5129.2.camel@henna.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1342547874.5129.2.camel@henna.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Martin-Éric Racine wrote:

> Signed-off-by: Martin-Éric Racine <martin-eric.racine@iki.fi>

Thanks.  This patch does many things at once instead of the usual
practice of "one patch per logical change", but oh well.

[...]
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -79,9 +79,9 @@ fwdir="$objtree/debian/fwtmp"
>  kernel_headers_dir="$objtree/debian/hdrtmp"
>  libc_headers_dir="$objtree/debian/headertmp"
>  packagename=linux-image-$version
> -fwpackagename=linux-firmware-image
>  kernel_headers_packagename=linux-headers-$version
>  libc_headers_packagename=linux-libc-dev
> +fwpackagename=firmware-linux

Micronit: any reason the lines are reordered here?

> @@ -188,17 +188,17 @@ This is a packacked upstream version of the Linux kernel.
>  The sources may be found at most Linux ftp sites, including:
>  ftp://ftp.kernel.org/pub/linux/kernel
>  
> -Copyright: 1991 - 2009 Linus Torvalds and others.
> +Copyright: 1991-2012 Linus Torvalds and others.
>  
> -The git repository for mainline kernel development is at:
> -git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> +The GIT repository for mainline kernel development is at:
> +git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

I personally like to spell it as "Git". ;-)

[...]
> @@ -273,6 +273,9 @@ if [ -e "$tmpdir/lib/firmware" ]; then
>  
>  Package: $fwpackagename
>  Architecture: all
> +Conflicts: firmware-linux-free, firmware-linux-nonfree
> +Provides: firmware-linux-free, firmware-linux-nonfree
> +Replaces: firmware-linux-free, firmware-linux-nonfree

I assume you mean Breaks+Replaces.  Do the files actually overlap,
or is this change being overly cautious?  I would expect the files
not to overlap because the package build with deb-pkg puts firmware
in a versioned subdirectory "/lib/firmware/<version>".

Hope that helps,
Jonathan
