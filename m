Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab0HaGdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:33:41 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36897 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab0HaGdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:33:40 -0400
Date: Tue, 31 Aug 2010 12:03:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "menage@google.com" <menage@google.com>,
        "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/5] cgroup: do ID allocation under css allocator.
Message-ID: <20100831063334.GM32680@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100825170435.15f8eb73.kamezawa.hiroyu@jp.fujitsu.com>
 <20100825170640.5f365629.kamezawa.hiroyu@jp.fujitsu.com>
 <20100825141500.GA32680@balbir.in.ibm.com>
 <20100826091346.88eb3ecc.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100826091346.88eb3ecc.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-08-26 09:13:46]:

> On Wed, 25 Aug 2010 19:45:00 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-08-25 17:06:40]:
> > 
> > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > 
> > > Now, css'id is allocated after ->create() is called. But to make use of ID
> > > in ->create(), it should be available before ->create().
> > > 
> > > In another thinking, considering the ID is tightly coupled with "css",
> > > it should be allocated when "css" is allocated.
> > > This patch moves alloc_css_id() to css allocation routine. Now, only 2 subsys,
> > > memory and blkio are useing ID. (To support complicated hierarchy walk.)
> >                        ^^^^ typo
> > > 
> > > ID will be used in mem cgroup's ->create(), later.
> > > 
> > > Note:
> > > If someone changes rules of css allocation, ID allocation should be moved too.
> > > 
> > 
> > What rules? could you please elaborate?
> > 
> See Paul Menage's mail. He said "allocating css object under kernel/cgroup.c
> will make kernel/cgroup.c cleaner." But it seems too big for my purpose.
> 
> > Seems cleaner, may be we need to update cgroups.txt?
> 
> Hmm. will look into.
>

OK, the patch looks good to me otherwise

 
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
