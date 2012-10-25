Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab2JYNlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:41:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43778 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759418Ab2JYNlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:41:39 -0400
Message-ID: <5089418C.1090802@suse.cz>
Date: Thu, 25 Oct 2012 15:41:32 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: fix xargs error on make distclean
References: <20121023013257.GA21775@localhost>
In-Reply-To: <20121023013257.GA21775@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.10.2012 03:32, Fengguang Wu wrote:
> /usr/bin/xargs: unmatched single quote; by default quotes are special to xargs unless you use the -0 option
> 
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index bb9fff2..e5a64cc 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1033,7 +1033,7 @@ distclean: mrproper
>  		-o -name '*.bak' -o -name '#*#' -o -name '.*.orig' \
>  		-o -name '.*.rej' \
>  		-o -name '*%' -o -name '.*.cmd' -o -name 'core' \) \
> -		-type f -print | xargs rm -f
> +		-type f -print0 | xargs -0 rm -f

As much as I like the find -print0 | xargs -0 construct, it is not
portable unfortunately.

Michal
