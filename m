Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab2JaRWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:22:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43285 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab2JaRWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:22:41 -0400
Date: Wed, 31 Oct 2012 10:22:37 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] cgroup: kill
 cgroup_subsys->__DEPRECATED_clear_css_refs
Message-ID: <20121031172237.GI2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-2-git-send-email-tj@kernel.org>
 <20121031143751.GA22809@dhcp22.suse.cz>
 <20121031164123.GD2945@htj.dyndns.org>
 <20121031164855.GI22809@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031164855.GI22809@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Michal.

On Wed, Oct 31, 2012 at 05:48:55PM +0100, Michal Hocko wrote:
> > The WARN_ON_ONCE() is just moved from the original
> > cgroup_call_pre_destroy().  We can add an error out there but that
> > makes future changes difficult.  It's a chicken and egg problem.  You
> > gotta break the loop somewhere.
> 
> I do not think this is that hard. You can simply change the return path
> on pre_destroy error by BUG_ON in "cgroup: deactivate CSS's and mark
> cgroup dead before invoking ->pre_destroy()". There is no chicke&egg
> problem here because once the group is marked dead and css frozen then
> the existing callbacks cannot possibly fail.
> Or am I missing your point?

I want to be able to move code verbatim in the later patch when
relocating ->pre_destroy() invocations.  Hmmm... alright, I'll make it
break out of pre_destroy() here and change it to WARN_ON_ONCE() later
on.

Thanks.

-- 
tejun
