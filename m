Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab0KDF6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 01:58:05 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:42339 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab0KDF6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 01:58:02 -0400
Date: Thu, 4 Nov 2010 06:58:00 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: [PATCH] kbuild, deb-pkg: fix Architecture field when cross
	compiling
Message-ID: <20101104055800.GA11781@merkur.ravnborg.org>
References: <4CD22ACF.1000407@asbjorn.it> <1288842244-6863-1-git-send-email-asbjorn@asbjorn.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288842244-6863-1-git-send-email-asbjorn@asbjorn.biz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 03:44:04AM +0000, Asbjoern Sloth Toennesen wrote:
> Attempt to guess the correct value of the Architecture control
> field, based on the ARCH environment variable. Fallback to letting
> deb-gencontrol use the host platform's architecture.
> 
> With this patch the following make command:
> 
> 	make ARCH=i386 deb-pkg
> 
> will output an i386 Debian package instead of an amd64 one,
> when run on amd64 machine.
> 
> Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
> ---
>  scripts/package/builddeb |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index 5f1e2fc..43b8826 100644
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -25,8 +25,23 @@ create_package() {
>  	chown -R root:root "$pdir"
>  	chmod -R go-w "$pdir"
>  
> +	# Attempt to find the correct Debian architecture
> +	local forcearch="" debarch=""
> +	case "$ARCH" in
> +	i386|ia64)
> +		debarch="$ARCH" ;;
> +	x86_64)
> +		debarch="amd64" ;;

On the commandline I can say ARCH=x86 - will it do the right thing then?

> +	*)
> +		grep -q CONFIG_ARM=y .config &&
> +			debarch=arm$(grep -q CONFIG_AEABI=y .config && echo el)
> +	esac

sparc may be know as sparc32, sparc64 and sparc these days.
I recall that at least in the past debian supported sparc.

	Sam
