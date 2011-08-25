Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1HYJD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 05:03:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37769 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab1HYJD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 05:03:28 -0400
Date: Thu, 25 Aug 2011 11:03:23 +0200
From: Tejun Heo <tj@kernel.org>
To: Paul Menage <paul@paulmenage.org>
Cc: rjw@sisk.pl, lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 2/6] cgroup: improve old cgroup handling in
 cgroup_attach_proc()
Message-ID: <20110825090323.GD3286@htj.dyndns.org>
References: <1314138000-2049-1-git-send-email-tj@kernel.org>
 <1314138000-2049-3-git-send-email-tj@kernel.org>
 <CALdu-PAj1ZUmB2ixxA6yeppB8MerBGk1cSeQadobH0H4cRSe7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALdu-PAj1ZUmB2ixxA6yeppB8MerBGk1cSeQadobH0H4cRSe7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 25, 2011 at 01:51:39AM -0700, Paul Menage wrote:
> In particular, making the group flex-array entries contain both a task
> and a cgroup appears to be only necessary in order to skip tasks where
> new_cgroup == old_cgroup. Can't we get the same effect by simply
> leaving all such tasks out of the flex-array in the first place?

In general, the interface *should* give full information to subsys
methods at each stage including the old cgroup each task is migrating
from and the new cgroup; otherwise, they soon end up developing weird
acrobatics to work around shortcomings in the interface or being
outright buggy, so let's please look past the fixes which are
necessary immediately and think about what a proper interface should
look like.

I mean, seriously, why did ->attach_task() take @new_cgroup when it's
called after migration happened while ->attach() had access to the old
cgroup of the last iterated task in the group?  What the hell does
that even mean?

And, why is this a big change?  The big part is change of interface
but that we need to do anyway.  This one is just adding an entry to
the flex array.

Thanks.

-- 
tejun
