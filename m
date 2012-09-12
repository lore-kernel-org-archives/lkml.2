Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179Ab2ILQBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:01:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62950 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758974Ab2ILQBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:01:19 -0400
Message-ID: <5050B1CA.7090208@gmail.com>
Date: Wed, 12 Sep 2012 18:01:14 +0200
From: Zdenek Kaspar <zkaspar82@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.7) Gecko/20120829 Thunderbird/10.0.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Kbuild: use normal compression settings for tar*-pkg
References: <1347133679-14641-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1347133679-14641-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2012 09:47 PM, Andi Kleen wrote:
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
> 
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
>  		file_ext=".gz"
>  		;;
>  	tarbz2-pkg)
> -		compress="bzip2 -c9"
> +		compress="bzip2"
>  		file_ext=".bz2"
>  		;;
>  	tarxz-pkg)
> -		compress="xz -c9"
> +		compress="xz"
>  		file_ext=".xz"
>  		;;
>  	*)

Maybe add new default compression options or rename actual ones to -hc-
(high compression) if users dont like it much?

Z.
