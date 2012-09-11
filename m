Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893Ab2IKSjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:39:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758762Ab2IKSjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:39:01 -0400
Date: Tue, 11 Sep 2012 14:38:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizf@cn.fujitsu.com>, Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC cgroup/for-3.7] cgroup: mark subsystems with broken
 hierarchy support and whine if cgroups are nested for them
Message-ID: <20120911183831.GA17113@redhat.com>
References: <20120910223125.GC7677@google.com>
 <20120911145106.GG12039@redhat.com>
 <20120911171601.GN7677@google.com>
 <20120911173524.GJ12039@redhat.com>
 <20120911175515.GP7677@google.com>
 <20120911181600.GK12039@redhat.com>
 <20120911182210.GQ7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911182210.GQ7677@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 11:22:10AM -0700, Tejun Heo wrote:

[..]
> > The point I am trying to make is that deep hierarchies (5-6 levels) are
> > /going to be a reality and if accounting overhead is not manageable then
> > enabling hierarchy by default might not be a practical solution even
> > if you implement hierarchy support (like memory cgroup), and in that
> > case retaining .use_hierarchy will make sense.
> 
> That doesn't make any sense to me.  If you don't want feature and
> overhead of hierarchy, you just need to not create a hierarchy.  If
> hierarchical behavior isn't needed, why create hierarchy at all?

I think ease of use and creation in user space. Different subsystems
(systemd/libvirt etc), don't have to fight each other by keeping
cgroups at same level. So systemd can control top 2 level of hiearchies
and then libvirt can manage another 2-3 levels. systemd is not enforcing
any upper limits. And if libvirt wants to enforce upper memory limits per
VM, they can still easily do that using flat controller (and without
incurring the overhead of hierarchical accounting).

Having said that, I think somebody had mentioned that it would be nice
to have hierarchical features to that a limit can be imposed on a
group of virtual machines without having all virtual machines in
same cgroup.

So yes agreed that creating hierarchy and still not expecting hierarchical
behavior does not make much sense. I think it kind of worked for limited
requirements (per cgroup upper limit). I think once you make hierarchy
default and if accounting overhead shows up, then there will be noises
about introducing regression.

Anyway, thanks for the explanation. This roadmap of converting everything
to hierarchical by default sounds sane. (Hoepefully we will be able to
manage the overhead problem).

Thanks
Vivek
