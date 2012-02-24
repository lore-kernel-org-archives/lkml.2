Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab2BXLdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 06:33:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37514 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2BXLdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 06:33:32 -0500
Message-ID: <1330083196.11248.24.camel@twins>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Date: Fri, 24 Feb 2012 12:33:16 +0100
In-Reply-To: <20120223213847.GK19691@redhat.com>
References: <20120221211938.GE12236@google.com>
	 <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>
	 <1329990094.24994.64.camel@twins> <20120223213847.GK19691@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 16:38 -0500, Vivek Goyal wrote:
> > > Again, it does not mean I am advocating flat hiearchy. I am just wondering
> > > in case of fully nested hierarchies (task at same level as groups), how
> > > does one explain it to a layman user who understands things in terms of
> > > % of resources. 
> > 
> > If your complete control is % based then I would assume its a % of a %.
> > Simple enough.
> 
> But % of % will vary dynamically and not be static. So if root has got
> 100% of resources and we want 25% of that for a group, then hierarchy
> might look as follows.
> 
>                                 root
>                                 / | \
>                                T1 T2 g1
> 
> T1, T2 are tasks and g1 is the group needing 25% of root's resources. Now
> number of tasks running in parallel to g1 will determine its effective %
> and tasks come and go. So the only way to do this would be that move T1
> and T2 in a child group under root and make sure new tasks don't show up
> in root. 

Which is exactly that the scheduler stuff does.. so tough luck for the
sysad who can't grasp it.

> Otherwise creating a group under root does not ensure that you get minimum
> % of resource. It just makes sure that you can't get more than 25% of
> % resources when things are tight. 

You never said anything about minimum resource guarantees in the initial
problem statement.
