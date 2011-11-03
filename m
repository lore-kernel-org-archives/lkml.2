Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934359Ab1KCSaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 14:30:25 -0400
Received: from bender.cm4all.net ([87.106.27.49]:43058 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933762Ab1KCSaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 14:30:19 -0400
Date: Thu, 3 Nov 2011 19:30:18 +0100
From: Max Kellermann <mk@cm4all.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tim Hockin <thockin@hockin.org>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] new cgroup controller "fork"
Message-ID: <20111103183018.GA28318@rabbit.intern.cm-ag>
References: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag>
 <20111103164302.GE8198@somewhere.redhat.com>
 <20111103171645.GA27887@rabbit.intern.cm-ag>
 <4EB2CEB2.7050800@parallels.com>
 <20111103174809.GA28108@rabbit.intern.cm-ag>
 <4EB2D451.4010607@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB2D451.4010607@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011/11/03 18:50, Glauber Costa <glommer@parallels.com> wrote:
> That still seems to be up to admin. If no processes are removed from
> the cgroup or included in the cgroup, the only action/verb the
> counter
> is concerned about is to fork. Under this circumstance, both seem
> equivalent from my PoV.

I'm confused.  One of us misunderstands the whole thing.

Examples of both controllers:

task_counter: task.limit=2.  Let's say the only process in that group
forks, then you have two processes.  Forking is disallowed from now
on.  The child process exits, and there's only one left - which is
allowed to fork!  The group may bounce between 0 and 2 processes
forever.

cgroup_fork: fork.remaining=2.  Now let's say we have one thousand
processes in that group!  One of those forks (allowed).  And it forks
again (allowed).  And tries again - blocked because "fork.remaining"
has reached zero.  We have 1002 processes; when 1001 of those
processes exit, one remains, but it is still disallowed to fork,
because "fork.remaining" is still zero.  It will remaing zero until
somebody with write permissions raises it again.

Did I get it wrong?  To me, that is not look equivalent at all.

Max
