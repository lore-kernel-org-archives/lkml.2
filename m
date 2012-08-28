Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab2H1GgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 02:36:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab2H1Gf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 02:35:59 -0400
Date: Tue, 28 Aug 2012 08:35:40 +0200
From: Andrew Jones <drjones@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>, avi@redhat.com, acme@infradead.org,
        mtosatti@redhat.com, mingo@elte.hu, xiaoguangrong@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 3/3] KVM: perf: kvm events analysis tool
Message-ID: <20120828063539.GA2280@turtle.usersys.redhat.com>
References: <1346061106-5364-1-git-send-email-haodong@linux.vnet.ibm.com>
 <1346061106-5364-4-git-send-email-haodong@linux.vnet.ibm.com>
 <20120827155331.GA18224@turtle.usersys.redhat.com>
 <503BCBCC.8060509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503BCBCC.8060509@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 01:34:36PM -0600, David Ahern wrote:
> On 8/27/12 9:53 AM, Andrew Jones wrote:
> >On Mon, Aug 27, 2012 at 05:51:46PM +0800, Dong Hao wrote:
> >
> ><snip>
> >
> >>+struct event_stats {
> >>+	u64 count;
> >>+	u64 time;
> >>+
> >>+	/* used to calculate stddev. */
> >>+	double mean;
> >>+	double M2;
> >>+};
> >
> >How about moving the stats functions from builtin-stat.c to e.g.
> >util/stats.c, and then reusing them? Then this struct (which I would
> >rename to kvm_event_stats) would look like this
> >
> >struct kvm_event_stats {
> >         u64 time;
> >         struct stats stats;
> >};
> >
> >of course the get_event_ accessor generators would need tweaking
> 
> Given the history of the command (first submitted back in February)
> code refactoring can wait until there is a second user for the stats
> code.

This is the second user. As I said, move the stats code from
builtin-stat.c. Or are you suggesting to duplicate the code once,
and then refactor the second (really the third) time it's needed?

Drew
