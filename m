Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2GXVo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 17:44:28 -0400
Received: from lobo.ruivo.org ([173.14.175.98]:42375 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab2GXVo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 17:44:27 -0400
Date: Tue, 24 Jul 2012 17:44:10 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Aristeu Rozanski <aris@redhat.com>,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hillf Danton <dhillf@gmail.com>, Kay Sievers <kay@redhat.com>
Subject: Re: [PATCH v3 0/3] cgroup: add xattr support
Message-ID: <20120724214410.GA14574@cathedrallabs.org>
References: <20120702142925.795007114@napanee.usersys.redhat.com>
 <20120717204126.GE24336@google.com>
 <alpine.LSU.2.00.1207181237010.2160@eggly.anvils>
 <20120718221044.GJ24336@google.com>
 <alpine.LSU.2.00.1207181736020.3323@eggly.anvils>
 <20120720175959.GA32741@cathedrallabs.org>
 <alpine.LSU.2.00.1207221136160.1896@eggly.anvils>
 <20120723181252.GW14236@cathedrallabs.org>
 <20120724182809.GD5776@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120724182809.GD5776@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 11:28:09AM -0700, Tejun Heo wrote:
> On Mon, Jul 23, 2012 at 02:12:52PM -0400, Aristeu Rozanski wrote:
> > > Will "lsattr -R" in the cgroupfs mountpoint do enough to judge how
> > > much memory is being used in this way?  I expect not, but I'm
> > > unfamliar with it: you may need to show counts elsewhere.
> > 
> > that's for ext{2,3,4} file attributes, not extended attributes. but agreed,
> > there's a need to have this stat somewhere. Tejun, any ideas?
> 
> No idea.  Don't we need some mechanism to limit the amount of memory
> consumed too?  Also, do you know what type of metadata systemd is
> trying to store in cgroupfs?  Depending on the size requirement, it
> might not be worth it to implement it using kernel memory.

AFAIK, the memcg should be able to account for slab usage too already or soon.
Talked briefly with one of systemd developers, Kay Sievers (Cc'd), and they
initially would have the main PID of the cgroup (systemd uses a cgroup per
service), so I suspect the usage will be low.

Another use is trying to use selinux to limit the access to cgroups for using
with containers.

-- 
Aristeu

