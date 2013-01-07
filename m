Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab3AGQmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:42:14 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42111 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab3AGQmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:42:11 -0500
Date: Mon, 7 Jan 2013 08:42:06 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: paul@paulmenage.org, glommer@parallels.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, mhocko@suse.cz, bsingharora@gmail.com,
        hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/13] cpuset: make CPU / memory hotplug propagation
 asynchronous
Message-ID: <20130107164206.GG3926@htj.dyndns.org>
References: <1357248967-24959-1-git-send-email-tj@kernel.org>
 <1357248967-24959-11-git-send-email-tj@kernel.org>
 <50E935D5.4040402@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50E935D5.4040402@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 04:29:09PM +0800, Li Zefan wrote:
> > +static void schedule_cpuset_propagate_hotplug(struct cpuset *cs)
> > +{
> > +	/*
> > +	 * Pin @cs.  The refcnt will be released when the work item
> > +	 * finishes executing.
> > +	 */
> > +	if (!css_tryget(&cs->css))
> > +		return;
> > +
> > +	/*
> > +	 * Queue @cs->empty_cpuset_work.  If already pending, lose the css
> 
> cs->hotplug_work

Thanks.  Patch updated.

-- 
tejun
