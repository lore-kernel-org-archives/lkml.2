Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab1FOUN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:13:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab1FOUNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:13:55 -0400
Date: Wed, 15 Jun 2011 22:13:53 +0200
From: Michal Marek <mmarek@suse.cz>
To: Andy Whitcroft <apw@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] perf: clear out make flags when calling kernel make
 kernelver
Message-ID: <20110615201353.GA15999@sepie.suse.cz>
References: <1308144900-1945-1-git-send-email-apw@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308144900-1945-1-git-send-email-apw@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 02:35:00PM +0100, Andy Whitcroft wrote:
> When generating the perf version from the kernel version using 'make
> kernelver' it is necessary to clear out any MAKEFLAGS otherwise they may
> trigger additional output which pollute the contents.
> 
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---
>  tools/perf/util/PERF-VERSION-GEN |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
> index 9c5fb4d..ad73300 100755
> --- a/tools/perf/util/PERF-VERSION-GEN
> +++ b/tools/perf/util/PERF-VERSION-GEN
> @@ -23,7 +23,7 @@ if test -d ../../.git -o -f ../../.git &&
>  then
>  	VN=$(echo "$VN" | sed -e 's/-/./g');
>  else
> -	VN=$(make -sC ../.. kernelversion)
> +	VN=$(MAKEFLAGS= make -sC ../.. kernelversion)
>  fi

Thanks, applied to kbuild-2.6.git#rc-fixes.

Michal
