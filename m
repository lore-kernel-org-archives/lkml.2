Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab2INT31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 15:29:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759973Ab2INT3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 15:29:24 -0400
Date: Fri, 14 Sep 2012 15:28:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
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
Message-ID: <20120914192840.GG6221@redhat.com>
References: <20120913205827.GO7677@google.com>
 <20120914180754.GF6221@redhat.com>
 <20120914185324.GI17747@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914185324.GI17747@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 11:53:24AM -0700, Tejun Heo wrote:

[..]
> In addition, for some resources, granularity beyond certain point
> simply doesn't work.  Per-service granularity might make sense for cpu
> but applying it by default would be silly for blkio.

Hmm.., In that case how libvirt will make use of blkio in the proposed
scheme. We can't disable blkio nesting at "system" level. So We will
have to disable it at each service level  except "libvirtd" so that
libvirt can use blkio for its virtual machines.

That means blkio will see each service in a cgroup of its own and if 
that does not make sense by default, its a problem. In the existing
scheme, atleast every service does not show up in its cgroup from
blkio point of view. Everthig is in root and libvirt can create its
own cgroups, keeping number of cgroups small.

Thanks
Vivek
