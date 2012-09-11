Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2IKAqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 20:46:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:17233 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab2IKAqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 20:46:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,400,1344236400"; 
   d="scan'208";a="220494471"
Date: Tue, 11 Sep 2012 08:46:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Kbuild: use normal compression settings for tar*-pkg
Message-ID: <20120911004633.GA21147@localhost>
References: <1347133679-14641-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347133679-14641-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2012 at 12:47:59PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> For large kernel configurations (like a distribution kernel)
> targz-pkg takes a quite long time to just do the compression.
> I clocked it at 15+mins for a SUSE kernel like config on a fast
> system.  And tarxz and bzip2 are even slower.
> 
> The main reason is that the script that is doing the taring sets
> the highest compression level (-9).  When I change it to just
> use the defaults the gzip time for the same kernel goes down
> to ~3 mins. I haven't tested xz and bzip, but I expect those
> to be much faster too.
> 
> I'm not willing to wait that long for a small compression
> gain. So just change the script to use the defaults.

Makes sense to me.

Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  scripts/package/buildtar |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/package/buildtar b/scripts/package/buildtar
> index 8a7b155..632377f 100644
> --- a/scripts/package/buildtar
> +++ b/scripts/package/buildtar
> @@ -28,15 +28,15 @@ case "${1}" in
>  		file_ext=""
>  		;;
>  	targz-pkg)
> -		compress="gzip -c9"
> +		compress="gzip"

-c should be kept because it means --stdout and --keep

>  		file_ext=".gz"
>  		;;
>  	tarbz2-pkg)
> -		compress="bzip2 -c9"
> +		compress="bzip2"

ditto

>  		file_ext=".bz2"
>  		;;
>  	tarxz-pkg)
> -		compress="xz -c9"
> +		compress="xz"

ditto

>  		file_ext=".xz"
>  		;;
>  	*)
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
