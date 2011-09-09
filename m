Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499Ab1IIMbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 08:31:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55314 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab1IIMbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 08:31:34 -0400
Date: Fri, 9 Sep 2011 14:31:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 06/12] cgroups: Add res counter common ancestor searching
Message-ID: <20110909123123.GA14072@somewhere.redhat.com>
References: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
 <1315267986-28937-7-git-send-email-fweisbec@gmail.com>
 <20110906152129.c6136981.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906152129.c6136981.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 03:21:29PM -0700, Andrew Morton wrote:
> On Tue,  6 Sep 2011 02:13:00 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > +struct res_counter *
> > +res_counter_common_ancestor(struct res_counter *r1, struct res_counter *r2)
> > +{
> > +	struct res_counter *iter;
> > +
> > +	while (r1) {
> > +		iter = r2;
> > +		while (iter) {
> > +			if (iter == r1)
> > +				return iter;
> > +			iter = iter->parent;
> > +		}
> > +
> > +		r1 = r1->parent;
> > +	}
> > +
> > +	return NULL;
> > +}
> 
> cgroup_mutex, one assumes?

No, a cgroup can't move to other parents, they remain stable
as long as they have children (if I understood correctly).
So this mirrors to res_counters.

In fact res counters is just a library, pretty much like
lists, except they are only used by cgroups for now, so it's up
to the caller to guarantee the stability of its objects.

But yeah the documentation for this function is missing. I'm
adding some comments in the file.
