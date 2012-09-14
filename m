Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921Ab2INSxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:53:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54551 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab2INSxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:53:30 -0400
Date: Fri, 14 Sep 2012 11:53:24 -0700
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
Message-ID: <20120914185324.GI17747@google.com>
References: <20120913205827.GO7677@google.com>
 <20120914180754.GF6221@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914180754.GF6221@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Fri, Sep 14, 2012 at 02:07:54PM -0400, Vivek Goyal wrote:
> I am curious that why are you planning to provide capability of controller
> specific view of hierarchy. To me it sounds pretty close to having
> separate hierarchies per controller. Just that it is a little more
> restricted configuration. 

I think it's a lot less crazy and gives us a way to bind a resource to
a set of controller cgroups regardless which task is looking at it,
which is something we're sorely missing now.

> IOW, who is is the user of this functionality and who is asking for it.
> Can we go all out where all controllers have only one hierarchy view.

I think the issue is that controllers inherently have overhead and
behavior alterations depending on the tree organization.  At least
from the usage I see from google which uses nested cgroups
extensively, at least that level of flexibility seems necessary.

In addition, for some resources, granularity beyond certain point
simply doesn't work.  Per-service granularity might make sense for cpu
but applying it by default would be silly for blkio.

Thanks.

-- 
tejun
