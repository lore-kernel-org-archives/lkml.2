Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab1IHNZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 09:25:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58021 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708Ab1IHNZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 09:25:40 -0400
Date: Thu, 8 Sep 2011 15:25:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>
Subject: Re: [PATCH 02/12] cgroups: New resource counter inheritance API
Message-ID: <20110908132528.GB6222@somewhere>
References: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
 <1315267986-28937-3-git-send-email-fweisbec@gmail.com>
 <20110906151747.26aa4fd2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906151747.26aa4fd2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 03:17:47PM -0700, Andrew Morton wrote:
> On Tue,  6 Sep 2011 02:12:56 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > +void res_counter_inherit(struct res_counter *counter, int member)
> > +{
> > +	struct res_counter *parent;
> > +	unsigned long long val;
> > +
> > +	parent = counter->parent;
> > +	if (parent) {
> > +		val = res_counter_read_u64(parent, member);
> > +		res_counter_write_u64(counter, member, val);
> > +	}
> > +}
> 
> What locking protects the read-modify-write?  If none, please fix,
> otherwise please document it.
> 
> All of kernel/res_counter.c is charmingly undocumented.

How should I address your reviews now that you've applied these
patches? Would you prefer me to send new patches on top of -mm?

Also Tejun has patches that conflict with mine. But I believe
-mm is on top of -next, so perhaps I should rebase those patches
when his branch reach -next? Or something else?
