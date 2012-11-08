Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab2KHOkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:40:00 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63936 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab2KHOj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:39:57 -0500
Date: Thu, 8 Nov 2012 06:39:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH 6/9] cgroup_freezer: make freezer->state mask of flags
Message-ID: <20121108143952.GD12973@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-7-git-send-email-tj@kernel.org>
 <20121108103928.GD31821@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108103928.GD31821@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Thu, Nov 08, 2012 at 11:39:28AM +0100, Michal Hocko wrote:
> On Sat 03-11-12 01:38:32, Tejun Heo wrote:
> > freezer->state was an enum value - one of THAWED, FREEZING and FROZEN.
> > As the scheduled full hierarchy support requires more than one
> > freezing condition, switch it to mask of flags.  If FREEZING is not
> > set, it's thawed.  FREEZING is set if freezing or frozen.  If frozen,
> > both FREEZING and FROZEN are set.  Now that tasks can be attached to
> > an already frozen cgroup, this also makes freezing condition checks
> > more natural.
> > 
> > This patch doesn't introduce any behavior change.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> I think it would be nicer to use freezer_state_flags enum rather than
> unsigned int for the state. I would even expect gcc to complain about
> that but it looks like -fstrict-enums is c++ specific (so long enum
> safety).

But if you use it as flag bits, the resulting value no longer is
inside the defined enum values.  Isn't that weird?

Thanks.

-- 
tejun
