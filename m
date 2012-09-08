Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab2IHRuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:50:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54246 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab2IHRuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:50:11 -0400
Date: Sat, 8 Sep 2012 10:50:07 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7 V6] workqueue: fix hoplug things
Message-ID: <20120908175007.GF10788@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
 <CACvQF50he+TtSqRBA-WAbGNqu4BRKtDQoP67ukEhinO3iDRPcg@mail.gmail.com>
 <20120908173751.GC10788@dhcp-172-17-108-109.mtv.corp.google.com>
 <CACvQF50cY8YEx30DR8K0KHF4pkc3f2b4WxVz_1bAxwbXoGMrBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF50cY8YEx30DR8K0KHF4pkc3f2b4WxVz_1bAxwbXoGMrBg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Sun, Sep 09, 2012 at 01:46:59AM +0800, Lai Jiangshan wrote:
> > * Instead of MANAGING, add pool->manager.
> >
> > * Fix the idle depletion bug by using pool->manager for exclusion and
> >   always grabbing pool->manager_mutex.  Hotplug can use pool->manager
> >   to schedule rebind work (or UNBIND) to the manager.
> >
> > Thoughts?
> 
> Don't need.  my worry is wrong.

So, your worry was incorrect and the above is what we're gonna do, no?

> > Also, can you please base the fix patches on top of wq/for-3.6-fixes?
> > It's getting quite confusing.
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.6-fixes
> 
> I base on wq/for-3.7 of several days ago.
> 
> I can change the base, but which blanch should patch5,6,7 base on?

Please create two patches, first introducing pool->manager_mutex and
second fixing the depletion bug by making manager always grab
manager_mutex on top of wq/for-3.6-fixes.  For the rest of the series,
please wait for me to merge the for-3.6-fixes into for-3.7 and base on
top of them and *please* stop sending restructuring patches before the
fixes are settled.  It's wasting time for both of us.

Thanks.

-- 
tejun
