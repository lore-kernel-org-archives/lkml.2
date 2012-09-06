Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab2IFPLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:11:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22407 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab2IFPLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:11:37 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=zgiTqp1681AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=SlKO6I3lSDoA:10 a=Kqkge5DqwmKkmokaOH0A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346944293.1680.26.camel@gandalf.local.home>
Subject: Re: [PATCH v3 01/17] hashtable: introduce a small and naive
 hashtable
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Pedro Alves <palves@redhat.com>, Tejun Heo <tj@kernel.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, mingo@elte.hu,
        ebiederm@xmission.com, aarcange@redhat.com, ericvh@gmail.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, axboe@kernel.dk,
        agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        ccaulfie@redhat.com, teigland@redhat.com, Trond.Myklebust@netapp.com,
        bfields@fieldses.org, fweisbec@gmail.com, jesse@nicira.com,
        venkat.x.venkatsubra@oracle.com, ejt@redhat.com, snitzer@redhat.com,
        edumazet@google.com, linux-nfs@vger.kernel.org, dev@openvswitch.org,
        rds-devel@oss.oracle.com, lw@cn.fujitsu.com
Date: Thu, 06 Sep 2012 11:11:33 -0400
In-Reply-To: <20120906145545.GA17332@leaf>
References: <503C95E4.3010000@gmail.com> <20120828101148.GA21683@Krystal>
	 <503CAB1E.5010408@gmail.com> <20120828115638.GC23818@Krystal>
	 <20120828230050.GA3337@Krystal>
	 <1346772948.27919.9.camel@gandalf.local.home> <50462C99.5000007@redhat.com>
	 <50462EE8.1090903@redhat.com> <20120904170138.GB31934@Krystal>
	 <5048AAF6.5090101@gmail.com> <20120906145545.GA17332@leaf>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 07:55 -0700, Josh Triplett wrote:

> > My solution to making 'break' work in the iterator is:
> > 
> > 	for (bkt = 0, node = NULL; bkt < HASH_SIZE(name) && node == NULL; bkt++)
> > 		hlist_for_each_entry(obj, node, &name[bkt], member)
> > 
> 
> Looks reasonable.  However, it would break (or rather, not break) on
> code like this:
> 
> 	hash_for_each_entry(...) {
> 		if (...) {
> 			foo(node);
> 			node = NULL;
> 			break;
> 		}
> 	}
> 
> Hiding the double loop still seems error-prone.

We've already had this conversation ;-)  A guess a big comment is in
order:

/*
 * NOTE!  Although this is a double loop, 'break' still works because of
 *        the 'node == NULL' condition in the outer loop. On break of
 *        the inner loop, node will be !NULL, and the outer loop will
 *        exit as well.
 */

-- Steve


