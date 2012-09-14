Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab2INToq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 15:44:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48313 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab2INToo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 15:44:44 -0400
Date: Fri, 14 Sep 2012 12:44:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120914194439.GP17747@google.com>
References: <20120913205827.GO7677@google.com>
 <20120914180754.GF6221@redhat.com>
 <20120914185324.GI17747@google.com>
 <20120914192840.GG6221@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914192840.GG6221@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Fri, Sep 14, 2012 at 03:28:40PM -0400, Vivek Goyal wrote:
> Hmm.., In that case how libvirt will make use of blkio in the proposed
> scheme. We can't disable blkio nesting at "system" level. So We will
> have to disable it at each service level  except "libvirtd" so that
> libvirt can use blkio for its virtual machines.
> 
> That means blkio will see each service in a cgroup of its own and if 
> that does not make sense by default, its a problem. In the existing

Yeap, if libvirtd wants use blkcg, blkcg will be enabled upto
libvirtd's root.  It might not be optimal but I think it makes sense.
If you want to excercise hierarchical control on a resource, the only
sane way is sticking to the hierarchy until it reaches root.

> scheme, atleast every service does not show up in its cgroup from
> blkio point of view. Everthig is in root and libvirt can create its
> own cgroups, keeping number of cgroups small.

Even a broken clock is right twice a day.  I don't think this is a
behavior we can keep for the sake of "but if we do this ass-weird
thing, we can bypass the overhead for XYZ" when it breaks so many
fundamental things.

I think there currently is too much (broken) flexibility and intent to
remove it.  That doesn't mean that removeing all flexibility is the
right direction.  It inherently is a balancing act and I think the
proposed solution is a reasonable tradeoff.  There's important
difference between causing full overhead by default for all users and
requiring some overhead when the use case at hand calls for the
functionality.

Thanks.

-- 
tejun
