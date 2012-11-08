Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab2KHOjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:39:01 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45471 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab2KHOi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:38:58 -0500
Date: Thu, 8 Nov 2012 06:38:53 -0800
From: Tejun Heo <tj@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 6/9] cgroup_freezer: make freezer->state mask of flags
Message-ID: <20121108143853.GC12973@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-7-git-send-email-tj@kernel.org>
 <509B371E.9050005@jp.fujitsu.com>
 <20121108044255.GG2660@mtj.dyndns.org>
 <509B3C72.3050904@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509B3C72.3050904@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kamezawa.

On Thu, Nov 08, 2012 at 02:00:34PM +0900, Kamezawa Hiroyuki wrote:
> (2012/11/08 13:42), Tejun Heo wrote:
> >Hello, Kame.
> >
> >On Thu, Nov 08, 2012 at 01:37:50PM +0900, Kamezawa Hiroyuki wrote:
> >>How about
> >>enum {
> >>    __CGROUP_FREEZING,
> >>    __CGROUP_FROZEN,
> >>};
> >>
> >>#define CGROUP_FREEZER_STATE_MASK  0x3
> >>#define CGROUP_FREEZER_STATE(state)	((state) & CGROUP_FREEZER_STATE_MASK)
> >>#define CGROUP_THAW(state)	(CGROUP_FREEZER_STATE(state) == 0)
> >>#define CGROUP_FREEZING(state)	(CGROUP_FREEZER_STATE(state) == __CGROUP_FREEZING)
> >>#define CGROUP_FROZEN(state)\
> >>	(CGROUP_FREEZER_STATE(state) == (__CGROUP_FREEZING | __CGROUP_FROZEN))
> >
> >I think it's a bit overdone and we have cases where we test for
> >FREEZING regardless of FROZEN and cases where test for FREEZING &&
> >!FROZEN.  We can have, say, CGROUP_FREZING() and then
> >CGROUP_FREEZING_BUT_NOT_FROZEN(), but it feels more like obfuscation
> >than anything else.
> >
> 
> Hm, then, I'm glad if I can see what combinations of flags are valid and
> meanings of them in source code comments.

Ooh, the following comment is added by a later patch when the whole
thing is complete.

/*
 * A cgroup is freezing if any FREEZING flags are set.  FREEZING_SELF is
 * set if "FROZEN" is written to freezer.state cgroupfs file, and cleared
 * for "THAWED".  FREEZING_PARENT is set if the parent freezer is FREEZING
 * for whatever reason.  IOW, a cgroup has FREEZING_PARENT set if one of
 * its ancestors has FREEZING_SELF set.
 */

Thanks.

-- 
tejun
