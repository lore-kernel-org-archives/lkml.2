Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1ASAyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 19:54:12 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40265 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab1ASAyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 19:54:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 19 Jan 2011 09:48:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>, minchan.kim@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm: add replace_page_cache_page() function
Message-Id: <20110119094813.2ea20439.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110119092733.4927f935.nishimura@mxp.nes.nec.co.jp>
References: <E1Pf9Zj-0002td-Ct@pomaz-ex.szeredi.hu>
	<20110118152844.88cfdc2c.akpm@linux-foundation.org>
	<20110119092733.4927f935.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jan 2011 09:27:33 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Tue, 18 Jan 2011 15:28:44 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 18 Jan 2011 12:18:11 +0100
> > Miklos Szeredi <miklos@szeredi.hu> wrote:
> > 
> > > +int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
> > > +{
> > > +	int error;
> > > +	struct mem_cgroup *memcg = NULL;
> > 
> > I'm suspecting that the unneeded initialisation was added to suppress a
> > warning?
> > 
> No.
> It's necessary for mem_cgroup_{prepare|end}_migration().
> mem_cgroup_prepare_migration() will return without doing anything in
> "if (mem_cgroup_disabled()" case(iow, "memcg" is not overwritten),
> but mem_cgroup_end_migration() depends on the value of "memcg" to decide
> whether prepare_migration has succeeded or not.
> This may not be a good implementation, but IMHO I'd like to to initialize
> valuable before using it in general.
> 

I think it can be initlized in mem_cgroup_prepare_migration().
I'll send patch later.

Thanks,
-Kame

