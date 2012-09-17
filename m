Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab2IQIoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:44:14 -0400
Received: from mx2.parallels.com ([64.131.90.16]:47757 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257Ab2IQIoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:44:10 -0400
Message-ID: <5056E1FC.1090508@parallels.com>
Date: Mon, 17 Sep 2012 12:40:28 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [RFC] cgroup TODOs
References: <20120913205827.GO7677@google.com> <20120914180754.GF6221@redhat.com> <20120914185324.GI17747@google.com> <20120914192840.GG6221@redhat.com> <20120914194439.GP17747@google.com> <20120914194950.GQ17747@google.com> <20120914203925.GR17747@google.com>
In-Reply-To: <20120914203925.GR17747@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2012 12:39 AM, Tejun Heo wrote:
> Hello, again.
> 
> On Fri, Sep 14, 2012 at 12:49:50PM -0700, Tejun Heo wrote:
>> That said, if someone can think of a better solution, I'm all ears.
>> One thing that *has* to be maintained is that it should be able to tag
>> a resource in such way that its associated controllers are
>> identifiable regardless of which task is looking at it.
> 
> So, I thought about it more.  How about we do "consider / ignore this
> node" instead of "(don't) nest beyond this level".  For example, let's
> assume a tree like the following.
> 
>         R
>      /  |  \
>     A   B   C
>    / \
>   AA AB
> 
> If we want to differentiate between AA and AB, we'll have to consider
> the whole tree with the previous sheme - A needs to nest, so R needs
> to nest and we end up with the whole tree.  Instead, if we have honor
> / ignore this node.  We can set the honor bit on A, AA and AB and see
> the tree as
> 
>         R
>      /
>     A
>    / \
>   AA AB
> 
> We still see the intermediate A node but can ignore the other
> branches.  Implementation and concept-wise, it's fairly simple too.
> For any given node and controller, you travel upwards until you meet a
> node which has the controller enabled and that's the cgroup the
> controller considers.
> 
> Thanks.
> 

That is exactly what I proposed in our previous discussions around
memcg, with files like "available_controllers" , "current_controllers".
Name chosen to match what other subsystems already do.

if memcg is not in "available_controllers" for a node, it cannot be seen
by anyone bellow that level.


