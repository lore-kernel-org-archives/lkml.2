Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1EDUsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:48:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:51630 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab1EDUsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:48:08 -0400
Date: Wed, 4 May 2011 22:48:07 +0200
From: Michal Marek <mmarek@suse.cz>
To: Nuno Subtil <subtil@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        maximilian attems <max@stro.at>
Subject: Re: [PATCH 1/1] deb-pkg: fix cross-compile build
Message-ID: <20110504204807.GB13293@sepie.suse.cz>
References: <1304488750-13606-1-git-send-email-subtil@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304488750-13606-1-git-send-email-subtil@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Maks to CC.

On Tue, May 03, 2011 at 10:59:10PM -0700, Nuno Subtil wrote:
> When generating the header package, scripts/package/builddeb was inferring the
> target architecture by looking at the output of dpkg --print-architecture. This
> allows KBUILD_DEBARCH to override that.
> 
> Signed-off-by: Nuno Subtil <subtil@gmail.com>
> ---
>  scripts/package/builddeb |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index f6cbc3d..9372145 100644
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -246,7 +246,12 @@ mkdir -p "$destdir"
>  (cd $srctree; tar -c -f - -T /tmp/files$$) | (cd $destdir; tar -xf -)
>  (cd $objtree; tar -c -f - -T /tmp/objfiles$$) | (cd $destdir; tar -xf -)
>  rm -f /tmp/files$$ /tmp/objfiles$$
> -arch=$(dpkg --print-architecture)
> +
> +if [ -n "$KBUILD_DEBARCH" ] ; then
> +	arch="$KBUILD_DEBARCH"
> +else
> +	arch=$(dpkg --print-architecture)
> +fi
>  
>  cat <<EOF >> debian/control
>  
> -- 
> 1.7.4.4
> 
> Please Cc me on any replies related to this patch.
> 
> Thanks,
> Nuno
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
