Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab2B1Vfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 16:35:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab2B1Vfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 16:35:44 -0500
Date: Tue, 28 Feb 2012 16:35:26 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120228213526.GI9920@redhat.com>
References: <20120221211938.GE12236@google.com>
 <20120222163858.GB4128@redhat.com>
 <20120222165714.GC4128@redhat.com>
 <1329990094.24994.64.camel@twins>
 <20120223213847.GK19691@redhat.com>
 <20120223223457.GJ22536@google.com>
 <20120228211627.GH9920@redhat.com>
 <1330464100.11248.94.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330464100.11248.94.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 10:21:40PM +0100, Peter Zijlstra wrote:
> On Tue, 2012-02-28 at 16:16 -0500, Vivek Goyal wrote:
> > 
> > But in this case, if task and groups are treated at same level, things
> > are not static and % share will change dynamically. 
> 
> which is exactly how the scheduler stuff behaves for the proportional
> bits.. so there's no reason not to do it too.

Yes this is how scheduler does to handle hierarchy. Treat task and group
at same level. Tejun was giving example of HTB and I was saying that there
class/queues or whatever, seem to be static and are not created
dynamically as tasks come in/go. So its not same.

So coming back to scheduler, handling tasks and groups at same level only
provides us with notion of priority for group. It does not provide any
notion of % (neither minimum, nor maximum). To calculate the % one needs
to know the proportioanal share/weight of all entities at same level and
currently number of entities vary hence % share can't be determined.

Whether it is a good thing or bad thing, I don't know. I think previous
design was allocating a group for every user. I guess, in that case we
will have fixed % share of each user (until and unless users are created/
removed).

So I don't know what's the right behavior. With this discussion, I am just
trying to make it explicit what to expect out of cgroup controllers. For
cpu controller, it is priority at the group level no fixed minimum/maximum
% shares. And that's a limitation of treating task and group at same level.

Thanks
Vivek
