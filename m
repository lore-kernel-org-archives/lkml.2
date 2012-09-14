Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab2INUjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 16:39:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62164 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab2INUjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 16:39:31 -0400
Date: Fri, 14 Sep 2012 13:39:25 -0700
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
Message-ID: <20120914203925.GR17747@google.com>
References: <20120913205827.GO7677@google.com>
 <20120914180754.GF6221@redhat.com>
 <20120914185324.GI17747@google.com>
 <20120914192840.GG6221@redhat.com>
 <20120914194439.GP17747@google.com>
 <20120914194950.GQ17747@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914194950.GQ17747@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Fri, Sep 14, 2012 at 12:49:50PM -0700, Tejun Heo wrote:
> That said, if someone can think of a better solution, I'm all ears.
> One thing that *has* to be maintained is that it should be able to tag
> a resource in such way that its associated controllers are
> identifiable regardless of which task is looking at it.

So, I thought about it more.  How about we do "consider / ignore this
node" instead of "(don't) nest beyond this level".  For example, let's
assume a tree like the following.

        R
     /  |  \
    A   B   C
   / \
  AA AB

If we want to differentiate between AA and AB, we'll have to consider
the whole tree with the previous sheme - A needs to nest, so R needs
to nest and we end up with the whole tree.  Instead, if we have honor
/ ignore this node.  We can set the honor bit on A, AA and AB and see
the tree as

        R
     /
    A
   / \
  AA AB

We still see the intermediate A node but can ignore the other
branches.  Implementation and concept-wise, it's fairly simple too.
For any given node and controller, you travel upwards until you meet a
node which has the controller enabled and that's the cgroup the
controller considers.

Thanks.

-- 
tejun
