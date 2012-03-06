Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab2CFJHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 04:07:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36189 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab2CFJHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 04:07:41 -0500
Date: Tue, 6 Mar 2012 10:07:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 0/3] KVM: perf: kvm events analysis tool
Message-ID: <20120306090730.GB27238@elte.hu>
References: <4F55D110.2020609@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F55D110.2020609@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> The output example is following:
> 
> #./perf kvm-events report --event mmio --vcpu 3

So we already have 'perf kvm':

 usage: perf kvm [<options>] {top|record|report|diff|buildid-list}

which is a sub-namespace for all things KVM instrumentation 
goodies. [ Arguably there should be a 'perf kvm trace' as well, 
but I digress. ]

So, your new tool has a similar workflow to:

  perf kvm record
  perf kvm report

but differs from it in terms of events used and in terms of 
reported output.

To me it appears that your tool is basically pretty similar to 
'perf stat', adapted to KVM, right?

So, could your new tool's workflow be simplified like this:

  perf kvm stat ..

?

To automatically stat all vcpus in the system, the well-known 
-a/--all-cpus system-wide method could be used:

  perf kvm stat -a ...

with stat output following immediately after it has finished.

It should also be possible to use those new events in a 
recording fashion - a new, rather logical command sub-space 
could be used for that:

 perf kvm stat record ...
 perf kvm stat report ...

[ This could be expanded to regular 'perf stat' as well: 'perf 
  stat record' and 'perf stat report' would be useful - but I 
  suspect that's outside the scope of your patches. ]

Thanks,

	Ingo
