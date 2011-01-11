Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab1AKOZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:25:42 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:40290 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1AKOZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:25:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ReKvYXayZMpx8hBqHFPe7mFWYzYxgNoCunbQ3CW+RVtT7oBU8musjw4bUWz56xxQy9
         Q3uBPrH8qpTtBBYx393nWiDqf1LsZbh1A+O91e9BcYGiSRy4uV33L6A8gLR645/u54p0
         yEHC7mHd0QVpvmZnLhMFHjKQAGMy4TOnMlILY=
Date: Tue, 11 Jan 2011 23:25:28 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        nishimura@mxp.nes.nec.co.jp, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: add replace_page_cache_page() function
Message-ID: <20110111142528.GF2113@barrios-desktop>
References: <E1Pcet8-0007kg-3R@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Pcet8-0007kg-3R@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 03:07:54PM +0100, Miklos Szeredi wrote:
> (resent with fixed CC list, sorry for the duplicate)
> 
> Thanks for the review.
> 
> Here's an updated patch.  Modifications since the last post:
> 
>  - don't pass gfp_mask (since it's only able to deal with GFP_KERNEL
>    anyway)
> 

I am not sure it's a good idea.
Now if we need just GFP_KERNEL, we can't make sure it in future.
Sometime we might need GFP_ATOMIC and friendd functions
(ex, add_to_page_cache_lru,add_to_page_cache_locked) already have gfp_mask.
It's a exported function so it's hard to modify it in future.

I want to keep it.
Instead of removing it, we can change mem_cgroup_prepare_migration as
getting gfp_mask.

-- 
Kind regards,
Minchan Kim
