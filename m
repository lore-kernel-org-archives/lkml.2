Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476Ab2IKO5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:57:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab2IKO5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:57:22 -0400
Date: Tue, 11 Sep 2012 10:54:24 -0400
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
Message-ID: <20120911145424.GH12039@redhat.com>
References: <20120910223125.GC7677@google.com>
 <20120911145106.GG12039@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911145106.GG12039@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 10:51:06AM -0400, Vivek Goyal wrote:
> On Mon, Sep 10, 2012 at 03:31:25PM -0700, Tejun Heo wrote:
> > Currently, cgroup hierarchy support is a mess.  cpu related subsystems
> > behave correctly - configuration, accounting and control on a parent
> > properly cover its children.  blkio and freezer completely ignore
> > hierarchy and treat all cgroups as if they're directly under the root
> > cgroup.  Others show yet different behaviors.
> > 
> > These differing interpretations of cgroup hierarchy make using cgroup
> > confusing and it impossible to co-mount controllers into the same
> > hierarchy and obtain sane behavior.
> > 
> > Eventually, we want full hierarchy support from all subsystems and
> > probably a unified hierarchy.  Users using separate hierarchies
> > expecting completely different behaviors depending on the mounted
> > subsystem is deterimental to making any progress on this front.
> > 
> > This patch adds cgroup_subsys.broken_hierarchy and sets it to %true
> > for controllers which are lacking in hierarchy support.  The goal of
> > this patch is two-fold.
> > 
> > * Move users away from using hierarchy on currently non-hierarchical
> >   subsystems, so that implementing proper hierarchy support on those
> >   doesn't surprise them.
> 
> I know two current/potential users. systemd and libvirt. They are
> anyway going to create hierarchy irrespective of the fact whether
> controller supports it or not.

Just to be little precise here. AFAIK, systemd only mounts blkio
controller on a separate hiearchy but does not create child cgroups
under it. So all the services should still run in root cgroup.

For libvirt, I think by default they had enabled using blkio
controller and they were creating hiearchies under that for each
virtual machine/container.

Thanks
Vivek
