Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab2IEPOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:14:47 -0400
Received: from vostochny.stro.at ([78.47.22.85]:41948 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab2IEPOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:14:45 -0400
Date: Wed, 5 Sep 2012 17:07:04 +0200
From: Maximilian Attems <max@stro.at>
To: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
Cc: Michal Marek <mmarek@suse.cz>, Linux Kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add mach-specific includes
Message-ID: <20120905150704.GB12713@stro.at>
References: <5040BFF3.6050705@suse.cz>
 <1346851836-18284-1-git-send-email-tzafrir.cohen@xorcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346851836-18284-1-git-send-email-tzafrir.cohen@xorcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Sep 2012, Tzafrir Cohen wrote:

> When building a deb package, the linux-headers package should also
> add arch/$ARCH/mach-*/include Required for arm and probably some
> other architectures: avr32 and blackfin.
> 
> This is needed to allow building modules using the headers package.
> 
> Signed-off-by: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
> ---
>  scripts/package/builddeb |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index acb8650..811a53a 100644
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -245,6 +245,9 @@ fi
>  # Build header package
>  (cd $srctree; find . -name Makefile\* -o -name Kconfig\* -o -name \*.pl > "$objtree/debian/hdrsrcfiles")
>  (cd $srctree; find arch/$SRCARCH/include include scripts -type f >> "$objtree/debian/hdrsrcfiles")
> +if echo arch/$SRCARCH/mach-*/include | grep -v '*' >/dev/null; then
> +	(cd $srctree; find arch/$SRCARCH/mach-*/include -type f >> "$objtree/debian/hdrsrcfiles")
> +fi
>  (cd $objtree; find arch/$SRCARCH/include .config Module.symvers include scripts -type f >> "$objtree/debian/hdrobjfiles")
>  destdir=$kernel_headers_dir/usr/src/linux-headers-$version
>  mkdir -p "$destdir"

no, please redirect find directly to stderr.

thank you.

-- 
maks
