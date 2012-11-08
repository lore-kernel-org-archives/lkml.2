Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab2KHRRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:17:50 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51553 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab2KHRRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:17:48 -0500
Date: Thu, 8 Nov 2012 09:17:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH 8/9] cgroup_freezer: add ->post_create() and
 ->pre_destroy() and track online state
Message-ID: <20121108171742.GJ12973@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-9-git-send-email-tj@kernel.org>
 <20121108132306.GH31821@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108132306.GH31821@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 08, 2012 at 02:23:06PM +0100, Michal Hocko wrote:
> On Sat 03-11-12 01:38:34, Tejun Heo wrote:
> > A cgroup is online and visible to iteration between ->post_create()
> > and ->pre_destroy().  This patch introduces CGROUP_FREEZER_ONLINE and
> > toggles it from the newly added freezer_post_create() and
> > freezer_pre_destroy() while holding freezer->lock such that a
> > cgroup_freezer can be reilably distinguished to be online.  This will
> > be used by full hierarchy support.
> 
> I am thinking whether freezer_pre_destroy is really needed. Once we
> reach pre_destroy then there are no tasks nor any children in the group
> so there is nobody to wake up if the group was frozen and the destroy
> callback is called after synchronize_rcu so the traversing should be
> safe.

Yeah, it might be true, but I'd still like to keep the offlining in
->pre_destroy() so that it's symmetrical w/ ->post_create().  I'll
rename and document the ops so that the roles of each are clearer.

Thanks.

-- 
tejun
