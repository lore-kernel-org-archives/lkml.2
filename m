Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161322Ab2COTpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:45:52 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34841 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161301Ab2COTpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:45:50 -0400
Date: Thu, 15 Mar 2012 12:45:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] cgroup: deprecate remount option changes mount option
Message-ID: <20120315194545.GG32137@google.com>
References: <20120314215228.GI7349@google.com>
 <20120315165655.GD32137@google.com>
 <20120315193635.GD32661@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315193635.GD32661@tango.0pointer.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 15, 2012 at 08:36:35PM +0100, Lennart Poettering wrote:
> > * release_agent update by remount: release_agent itself will be
> >   replaced with conventional fsnotify notification.
> 
> Just wondering, what kind of event do you plan to emit if a cgroup runs
> empty? To userspace, with fanotify, will this be FAN_MODIFY? I'd very
> much prefer if we only get events really when a group runs empty, and
> not each time a PID is added/removed from a cgroup, which FAN_NOTIFY
> might suggest?

MODIFY probably is the only thing which makes sense and I don't think
we would be emitting events for every task addition/removals.  That
better fits MODIFY events on the tasks file anyway.

Thanks.

-- 
tejun
