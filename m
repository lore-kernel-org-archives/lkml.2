Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab2IMRsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:48:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38522 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2IMRsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:48:22 -0400
Date: Thu, 13 Sep 2012 10:48:17 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Graf <tgraf@suug.ch>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH RFC cgroup/for-3.7] cgroup: mark subsystems with broken
 hierarchy support and whine if cgroups are nested for them
Message-ID: <20120913174817.GA7677@google.com>
References: <20120910223125.GC7677@google.com>
 <505055E5.90903@parallels.com>
 <20120912170357.GN7677@google.com>
 <5051C954.2080600@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5051C954.2080600@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Thu, Sep 13, 2012 at 03:53:56PM +0400, Glauber Costa wrote:
> Here is where the Kconfig option comes to play. If we do it in the
> kernel, userspace doesn't have to do anything. I spoke with Lennart and
> Kay, and at least from a systemd PoV, they would much rather not provide
> a hack in userspace for a file that is scheduled to go away in any case
> - which I personally believe is a fair request.
> 
> It is a default, so the effect for the user is the same: After the
> machine boots, use_hierarchy = 1, and he can still flip to 0 for some time.

Alright, let's go Kconfig.  Let's just make sure that the transitional
nature is clearly labeled and the fact that the default config will
generate a warning when nested cgroups are created in memcg.  We can
then coordinate the flip with distros.  Can you please repost the
Kconfig patch?

> > Setting mark on a parent should be reflected on all its children w/o
> > their own explicit settings.
> 
> That is clear, and better behavior than we have today. What I mean, is
> that by setting its own marking, the child can pretty much "escape" the
> group.
> 
> The ideal solution - from this point of view only - would be to have
> more than one marking, and mark with all the way down to the root. So if
> you have an iptables rule to match one marking, it still applies to the
> kids. And you can still have extra markings.
> 
> I am not sure this is feasible, though, in which case your solution
> could be a good compromise. But please let's aim for it.

I don't think it supports multiple tags.  If that's possible, it would
be nice but I don't think it's a must.

Thanks.

-- 
tejun
