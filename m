Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab2ASDmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 22:42:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52870 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2ASDl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 22:41:59 -0500
Date: Wed, 18 Jan 2012 19:41:44 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Sasha Levin <levinsasha928@gmail.com>, hannes <hannes@cmpxchg.org>,
        mhocko@suse.cz, bsingharora@gmail.com, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [BUG] kernel BUG at mm/memcontrol.c:1074!
In-Reply-To: <20120119122354.66eb9820.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.LSU.2.00.1201181932040.2287@eggly.anvils>
References: <1326949826.5016.5.camel@lappy> <20120119122354.66eb9820.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jan 2012, KAMEZAWA Hiroyuki wrote:
> On Thu, 19 Jan 2012 07:10:26 +0200
> Sasha Levin <levinsasha928@gmail.com> wrote:
> 
> > Hi all,
> > 
> > During testing, I have triggered the OOM killer by mmap()ing a large block of memory. The OOM kicked in and tried to kill the process:
> > 
> 
> two questions.
> 
> 1. What is the kernel version  ?

It says 3.2.0-next-20120119-sasha #128

> 2. are you using memcg moutned ?

I notice that, unlike Linus's git, this linux-next still has
mm-isolate-pages-for-immediate-reclaim-on-their-own-lru.patch in.

I think that was well capable of oopsing in mem_cgroup_lru_del_list(),
since it didn't always know which lru a page belongs to.

I'm going to be optimistic and assume that was the cause.

Hugh
