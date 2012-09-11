Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab2IKSWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:22:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39390 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab2IKSWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:22:15 -0400
Date: Tue, 11 Sep 2012 11:22:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
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
Message-ID: <20120911182210.GQ7677@google.com>
References: <20120910223125.GC7677@google.com>
 <20120911145106.GG12039@redhat.com>
 <20120911171601.GN7677@google.com>
 <20120911173524.GJ12039@redhat.com>
 <20120911175515.GP7677@google.com>
 <20120911181600.GK12039@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911181600.GK12039@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Tue, Sep 11, 2012 at 02:16:00PM -0400, Vivek Goyal wrote:
> Ok, so whole point of warning seems to be so that we can change the
> behavior in future and say to user space they few kernel releases back we
> had started printing a warning that creating hierarchy is wrong and 
> move to a flat setup. So don't complain to us now.?

Yes, pretty much.  At the moment, it's simply broken.

> Are you planning to get rid of .user_hierarchy file from memory cgroup
> too? If you are planning not to put such a file in blkio controller,
> then it will make sense to remove it from mem_cgorup too.

Yes, or at least make it RO 1 eventually.

> The point I am trying to make is that deep hierarchies (5-6 levels) are
> /going to be a reality and if accounting overhead is not manageable then
> enabling hierarchy by default might not be a practical solution even
> if you implement hierarchy support (like memory cgroup), and in that
> case retaining .use_hierarchy will make sense.

That doesn't make any sense to me.  If you don't want feature and
overhead of hierarchy, you just need to not create a hierarchy.  If
hierarchical behavior isn't needed, why create hierarchy at all?

> IIUC, are you saying that now none of the controller will have flat
> hiearchy support because there is no way to be able to create flat 
> hierarchy. (Any new group is child of root group). So are we moving
> towards a model where every controller is hierarhical and there is
> no concept of flat hierarchy.

Yeap.

Thanks.

-- 
tejun
