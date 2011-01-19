Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab1ASBSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 20:18:36 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:55581 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab1ASBSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 20:18:35 -0500
Message-id: <isapiwc.47df251f.f8b.4d363a30.58500.62@mail.jp.nec.com>
In-Reply-To: <20110119094813.2ea20439.kamezawa.hiroyu@jp.fujitsu.com>
References: <E1Pf9Zj-0002td-Ct@pomaz-ex.szeredi.hu>
 <20110118152844.88cfdc2c.akpm@linux-foundation.org>
 <20110119092733.4927f935.nishimura@mxp.nes.nec.co.jp>
 <20110119094813.2ea20439.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 19 Jan 2011 10:11:12 +0900
From: nishimura@mxp.nes.nec.co.jp
Subject: Re: [PATCH v4] mm: add replace_page_cache_page() function
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>, minchan.kim@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 19 Jan 2011 09:27:33 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
>> On Tue, 18 Jan 2011 15:28:44 -0800
>> Andrew Morton <akpm@linux-foundation.org> wrote:
>> 
>> > On Tue, 18 Jan 2011 12:18:11 +0100
>> > Miklos Szeredi <miklos@szeredi.hu> wrote:
>> > 
>> > > +int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
>> > > +{
>> > > +	int error;
>> > > +	struct mem_cgroup *memcg = NULL;
>> > 
>> > I'm suspecting that the unneeded initialisation was added to suppress a
>> > warning?
>> > 
>> No.
>> It's necessary for mem_cgroup_{prepare|end}_migration().
>> mem_cgroup_prepare_migration() will return without doing anything in
>> "if (mem_cgroup_disabled()" case(iow, "memcg" is not overwritten),
>> but mem_cgroup_end_migration() depends on the value of "memcg" to decide
>> whether prepare_migration has succeeded or not.
>> This may not be a good implementation, but IMHO I'd like to to initialize
>> valuable before using it in general.
>> 
> 
> I think it can be initlized in mem_cgroup_prepare_migration().
> I'll send patch later.
> 
I see, thanks.

I think you know it, but just a note:
mem_cgroup_{try_charge|commit_charge}_swapin()
use the same logic, so try_charge_swapin() should also be changed
for consistency.

Thanks,
Daisuke Nishimura.
