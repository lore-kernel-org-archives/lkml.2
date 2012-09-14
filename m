Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab2INMzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:55:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617Ab2INMzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:55:16 -0400
Date: Fri, 14 Sep 2012 13:54:27 +0100
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Neil Horman <nhorman@tuxdriver.com>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        cgroups@vger.kernel.org, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120914125427.GW6819@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <20120913205827.GO7677@google.com>
 <1347621302.7172.22.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1347621302.7172.22.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 01:15:02PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-09-13 at 13:58 -0700, Tejun Heo wrote:
> >   The cpu ones handle nesting correctly - parent's accounting includes
> >   children's, parent's configuration affects children's unless
> >   explicitly overridden, and children's limits nest inside parent's. 
> 
> The implementation has some issues with fixed point math limitations on
> deep hierarchies/large cpu count, but yes.
> 
> Doing soft-float/bignum just isn't going to be popular I guess ;-)
> 
> People also don't seem to understand that each extra cgroup carries a
> cost and that nested cgroups are more expensive still, even if the
> intermediate levels are mostly empty (libvirt is a good example of how
> not to do things).
> 
> Anyway, I guess what I'm saying is that we need to work on the awareness
> of cost associated with all this cgroup nonsense, people seem to think
> its all good and free -- or not think at all, which, while depressing,
> seem the more likely option.

In defense of what libvirt is doing, I'll point out that the kernel
docs on cgroups make little to no mention of these performance / cost
implications, and the examples of usage given arguably encourage use
of deep hierarchies.

Given what we've now learnt about the kernel's lack of scalability
wrt cgroup hierarchies, we'll be changing the way libvirt deals with
cgroups, to flatten it out to only use 1 level by default. If the
kernel docs had clearly expressed the limitations & made better
recommendations on app usage we would never have picked the approach
we originally chose.

Regards,
Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
