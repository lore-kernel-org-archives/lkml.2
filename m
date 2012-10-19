Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426Ab2JSUCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 16:02:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56009 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab2JSUCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 16:02:39 -0400
Date: Fri, 19 Oct 2012 13:02:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Matt Helsley <matthltc@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, oleg@redhat.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup_freezer: allow migration
 regardless of freezer state and update locking
Message-ID: <20121019200235.GN13370@google.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <20121017191606.GA6223@us.ibm.com>
 <20121018211434.GI13370@google.com>
 <20121018222155.GB6223@us.ibm.com>
 <20121018223517.GQ13370@google.com>
 <20121018234726.GC6223@us.ibm.com>
 <20121019000153.GZ13370@google.com>
 <20121019012945.GD6223@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019012945.GD6223@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Matt.

On Thu, Oct 18, 2012 at 06:29:45PM -0700, Matt Helsley wrote:
> Yeah, that would be a nice cleanup too. I guess the ultra-careful way to
> remove this feature would be something like:
> 
> 	Add an internal migration restriction (which may or may not be
> 		exported as a userspace interface in a subsequent
> 		patch).
> 
> 	Make the cgroup freezer use it.
> 
> 	Make the cgroup freezer WARN_ONCE() when the subsystem is first
> 		mounted. Indicates that the behavior is going to
> 		change.
> 
> 	... time passes ...
> 
> 	Remove the use of the migration "lock" from the cgroup freezer
> 		and the WARN_ONCE().
> 
> Which would also make the feature more obvious.

I don't think I'm gonna go that far for this.  I don't think we need
cgroup migration locking after all.

Thanks.

-- 
tejun
