Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab0HBXt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 19:49:57 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36603 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab0HBXt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 19:49:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 3 Aug 2010 08:45:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/7][memcg] virtually indexed array library.
Message-Id: <20100803084500.8bf99ff2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100802180051.GX3863@balbir.in.ibm.com>
References: <20100727165155.8b458b7f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100727165303.7d7d18e9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100728124513.85bfa047.akpm@linux-foundation.org>
	<20100729093226.7b899930.kamezawa.hiroyu@jp.fujitsu.com>
	<20100729132703.2d53e8a4.kamezawa.hiroyu@jp.fujitsu.com>
	<20100802180051.GX3863@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010 23:30:51 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-07-29 13:27:03]:
> 
> > On Thu, 29 Jul 2010 09:32:26 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > On Wed, 28 Jul 2010 12:45:13 -0700
> > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > > My gut reaction to this sort of thing is "run away in terror".  It
> > > > encourages kernel developers to operate like lackadaisical userspace
> > > > developers and to assume that underlying code can perform heroic and
> > > > immortal feats.  But it can't.  This is the kernel and the kernel is a
> > > > tough and hostile place and callers should be careful and defensive and
> > > > take great efforts to minimise the strain they put upon other systems.
> > > > 
> > > > IOW, can we avoid doing this?
> > > > 
> > > 
> > 
> > I'll use pre-allocated pointer array in the next version. It's simple even
> > if a bit slow.
> > 
> > ==
> > struct mem_cgroup *mem_cgroups[CONFIG_MAX_MEM_CGROUPS] __read_mostly;
> > #define id_to_memcg(id)		mem_cgroups[id];
> > ==
> 
> Hmm.. I thought we were going to reuse css_id() and use that to get to
> the cgroup. May be I am missing something.
> 
?
lookup_css_id() requires multi-level table lookup because of radix-tree.
And compiler can't generate an optimized code. linear table lookup is quick.

-Kame


