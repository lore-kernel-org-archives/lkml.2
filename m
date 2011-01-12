Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab1ALAvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 19:51:01 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52541 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab1ALAu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 19:50:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 12 Jan 2011 09:44:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
        nishimura@mxp.nes.nec.co.jp, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: add replace_page_cache_page() function
Message-Id: <20110112094453.8197ee36.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110111142528.GF2113@barrios-desktop>
References: <E1Pcet8-0007kg-3R@pomaz-ex.szeredi.hu>
	<20110111142528.GF2113@barrios-desktop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011 23:25:28 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Tue, Jan 11, 2011 at 03:07:54PM +0100, Miklos Szeredi wrote:
> > (resent with fixed CC list, sorry for the duplicate)
> > 
> > Thanks for the review.
> > 
> > Here's an updated patch.  Modifications since the last post:
> > 
> >  - don't pass gfp_mask (since it's only able to deal with GFP_KERNEL
> >    anyway)
> > 
> 
> I am not sure it's a good idea.
> Now if we need just GFP_KERNEL, we can't make sure it in future.
> Sometime we might need GFP_ATOMIC and friendd functions
> (ex, add_to_page_cache_lru,add_to_page_cache_locked) already have gfp_mask.
> It's a exported function so it's hard to modify it in future.
> 
> I want to keep it.
> Instead of removing it, we can change mem_cgroup_prepare_migration as
> getting gfp_mask.
> 
you're right.

Thanks,
-Kame

