Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab1KVCVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 21:21:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47757 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758039Ab1KVCVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 21:21:23 -0500
Date: Mon, 21 Nov 2011 18:21:18 -0800
From: Tejun Heo <htejun@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        Tomasz Buchert <tomasz.buchert@inria.fr>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks
Message-ID: <20111122022118.GT25776@google.com>
References: <1321480234-29241-1-git-send-email-mhocko@suse.cz>
 <20111121230709.GR25776@google.com>
 <4ECB06D2.6060106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECB06D2.6060106@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 10:20:02AM +0800, Li Zefan wrote:
> Tejun Heo wrote:
> > Hello, Michal.
> > 
> > On Wed, Nov 16, 2011 at 10:50:34PM +0100, Michal Hocko wrote:
> >> +/* Task is frozen or will freeze immediately when next it gets woken */
> >> +static bool is_task_frozen_enough(struct task_struct *task)
> >> +{
> >> +	return frozen(task) ||
> >> +		(task_is_stopped_or_traced(task) && freezing(task));
> >> +}
> > 
> > Hmmm... w/ pending freezer updates, the above would always return
> > %true if there's freezing in progress, which can't be right.  Maybe
> 
> Only if the task is stopped/trace.

You're right, missed parantheses.

> If we try to freeze a stopped task, it will be kept in freezing state.
> 
> > just test stopped/traced?
> 
> This can trigger a BUG_ON in update_if_frozen(), because we always count a
> stopped task as frozen.

So, yeah, the patch looks good to me, but it still isn't difficult to
trigger BUG_ON() there.  We need a lot of fixes in cgroup_freezer.

Thanks.

-- 
tejun
