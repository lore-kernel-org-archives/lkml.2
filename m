Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934900Ab2JaBQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 21:16:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24072 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab2JaBQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 21:16:31 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=6MWR2sRkvj8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=SlKO6I3lSDoA:10 a=VwQbUJbxAAAA:8 a=5tQbYdXRjfr-eRnBsl8A:9 a=PUjeQqilurYA:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351646186.4004.41.camel@gandalf.local.home>
Subject: Re: [PATCH v8 01/16] hashtable: introduce a small and naive
 hashtable
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, paul.gortmaker@windriver.com, davem@davemloft.net,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org, josh@joshtriplett.org,
        eric.dumazet@gmail.com, mathieu.desnoyers@efficios.com,
        axboe@kernel.dk, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        ccaulfie@redhat.com, teigland@redhat.com, Trond.Myklebust@netapp.com,
        bfields@fieldses.org, fweisbec@gmail.com, jesse@nicira.com,
        venkat.x.venkatsubra@oracle.com, ejt@redhat.com, snitzer@redhat.com,
        edumazet@google.com, linux-nfs@vger.kernel.org, dev@openvswitch.org,
        rds-devel@oss.oracle.com, lw@cn.fujitsu.com
Date: Tue, 30 Oct 2012 21:16:26 -0400
In-Reply-To: <CA+1xoqeCKS2E4TWCUCELjDqV2pWS4v6EyV6K-=w-GRi_K6quiQ@mail.gmail.com>
References: <1351622772-16400-1-git-send-email-levinsasha928@gmail.com>
	 <20121030214257.GB2681@htj.dyndns.org>
	 <CA+1xoqeCKS2E4TWCUCELjDqV2pWS4v6EyV6K-=w-GRi_K6quiQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 20:33 -0400, Sasha Levin wrote:
> On Tue, Oct 30, 2012 at 5:42 PM, Tejun Heo <tj@kernel.org> wrote:
> > Hello,
> >
> > Just some nitpicks.
> >
> > On Tue, Oct 30, 2012 at 02:45:57PM -0400, Sasha Levin wrote:
> >> +/* Use hash_32 when possible to allow for fast 32bit hashing in 64bit kernels. */
> >> +#define hash_min(val, bits)                                                  \
> >> +({                                                                           \
> >> +     sizeof(val) <= 4 ?                                                      \
> >> +     hash_32(val, bits) :                                                    \
> >> +     hash_long(val, bits);                                                   \
> >> +})
> >
> > Doesn't the above fit in 80 column.  Why is it broken into multiple
> > lines?  Also, you probably want () around at least @val.  In general,
> > it's a good idea to add () around any macro argument to avoid nasty
> > surprises.
> 
> It was broken to multiple lines because it looks nicer that way (IMO).
> 
> If we wrap it with () it's going to go over 80, so it's going to stay
> broken down either way :)

({								      \
	sizeof(val) <= 4 ? hash_32(val, bits) : hash_long(val, bits); \
})

Is the better way to go. We are C programmers, we like to see the ?: on
a single line if possible. The way you have it, looks like three
statements run consecutively.

-- Steve


