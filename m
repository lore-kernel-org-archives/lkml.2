Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2HaNuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:50:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab2HaNuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:50:17 -0400
Message-ID: <5040C112.70501@suse.cz>
Date: Fri, 31 Aug 2012 15:50:10 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
Cc: Linux Kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] builddeb: remove unneeded explicit Architecture
References: <1344941092-31312-1-git-send-email-tzafrir.cohen@xorcom.com>
In-Reply-To: <1344941092-31312-1-git-send-email-tzafrir.cohen@xorcom.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Max to CC.

On 14.8.2012 12:44, Tzafrir Cohen wrote:
> Architecture was set explicitly in debian/control for one of the three
> packages (linux-libc-dev) but not for the other two. When cross-building
> it gives me an error:
> 
>   dpkg-gencontrol: error: current host architecture 'armhf' does not
>   appear in package's architecture list (amd64)
> 
> Also note that if used, dpkg --print-architecture should have been
> replaced with dpkg-architecture.
> 
> Signed-off-by: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
> ---
>  scripts/package/builddeb |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index acb8650..d9c71a6 100644
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -252,13 +252,12 @@ mkdir -p "$destdir"
>  (cd $objtree; tar -c -f - -T "$objtree/debian/hdrobjfiles") | (cd $destdir; tar -xf -)
>  ln -sf "/usr/src/linux-headers-$version" "$kernel_headers_dir/lib/modules/$version/build"
>  rm -f "$objtree/debian/hdrsrcfiles" "$objtree/debian/hdrobjfiles"
> -arch=$(dpkg --print-architecture)
>  
>  cat <<EOF >> debian/control
>  
>  Package: $kernel_headers_packagename
>  Provides: linux-headers, linux-headers-2.6
> -Architecture: $arch
> +Architecture: any
>  Description: Linux kernel headers for $KERNELRELEASE on $arch
>   This package provides kernel header files for $KERNELRELEASE on $arch
>   .

As the package contains files from arch/$SRCARCH/include, I doubt that
this is a valid change.

Michal
