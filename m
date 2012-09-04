Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab2IDPfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:35:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9138 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab2IDPfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:35:51 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=zgiTqp1681AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Md3Eq_kwYTQA:10 a=imTROTZUkysA:10 a=OQEzN_gqAOIA:10 a=pN9PhARNchwA:10 a=nFlYCK1qHmYA:10 a=EGDuWttHsakA:10 a=TiR09M0h3c4A:10 a=-rGry1Sg3DAA:10 a=71224Grfh94A:10 a=S_QucjnRiEgA:10 a=8tfgvxPDMX4A:10 a=eODW5OEf59EA:10 a=xkTuBmjMRih5i96pTVwA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346772948.27919.9.camel@gandalf.local.home>
Subject: Re: [PATCH v3 01/17] hashtable: introduce a small and naive
 hashtable
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Tejun Heo <tj@kernel.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, mingo@elte.hu,
        ebiederm@xmission.com, aarcange@redhat.com, ericvh@gmail.com,
        netdev@vger.kernel.org, josh@joshtriplett.org, eric.dumazet@gmail.com,
        axboe@kernel.dk, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        ccaulfie@redhat.com, teigland@redhat.com, Trond.Myklebust@netapp.com,
        bfields@fieldses.org, fweisbec@gmail.com, jesse@nicira.com,
        venkat.x.venkatsubra@oracle.com, ejt@redhat.com, snitzer@redhat.com,
        edumazet@google.com, linux-nfs@vger.kernel.org, dev@openvswitch.org,
        rds-devel@oss.oracle.com, lw@cn.fujitsu.com
Date: Tue, 04 Sep 2012 11:35:48 -0400
In-Reply-To: <20120828230050.GA3337@Krystal>
References: <20120824203332.GF21325@google.com> <5037E9D9.9000605@gmail.com>
	 <20120824212348.GK21325@google.com> <5038074D.300@gmail.com>
	 <20120824230740.GN21325@google.com> <20120825042419.GA27240@Krystal>
	 <503C95E4.3010000@gmail.com> <20120828101148.GA21683@Krystal>
	 <503CAB1E.5010408@gmail.com> <20120828115638.GC23818@Krystal>
	 <20120828230050.GA3337@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-28 at 19:00 -0400, Mathieu Desnoyers wrote:

> Looking again at:
> 
> +#define hash_for_each_size(name, bits, bkt, node, obj, member)                 \
> +       for (bkt = 0; bkt < HASH_SIZE(bits); bkt++)                             \
> +               hlist_for_each_entry(obj, node, &name[bkt], member)
> 
> you will notice that a "break" or "continue" in the inner loop will not
> affect the outer loop, which is certainly not what the programmer would
> expect!
> 
> I advise strongly against creating such error-prone construct.
> 

A few existing loop macros do this. But they require a do { } while ()
approach, and all have a comment.

It's used by do_each_thread() in sched.h and ftrace does this as well.
Look at kernel/trace/ftrace.c at do_for_each_ftrace_rec().

Yes it breaks 'break' but it does not break 'continue' as it would just
go to the next item that would have been found (like a normal for
would).

-- Steve


