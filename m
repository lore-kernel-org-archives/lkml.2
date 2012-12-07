Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423895Ab2LGSew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 13:34:52 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39932 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423878Ab2LGSeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 13:34:50 -0500
Message-ID: <50C2366C.3000204@linux.vnet.ibm.com>
Date: Sat, 08 Dec 2012 00:03:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, oleg@redhat.com,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/9] CPU hotplug: Provide APIs to prevent CPU offline
 from atomic context
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com> <20121207173759.27305.84316.stgit@srivatsabhat.in.ibm.com> <20121207175724.GA2821@htj.dyndns.org> <20121207181608.GB2821@htj.dyndns.org>
In-Reply-To: <20121207181608.GB2821@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120718-0260-0000-0000-000002443565
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 11:46 PM, Tejun Heo wrote:
> Hello, again.
> 
> On Fri, Dec 07, 2012 at 09:57:24AM -0800, Tejun Heo wrote:
>> possible.  Also, I think the right approach would be auditing each
>> get_online_cpus_atomic() callsites and figure out proper locking order
>> rather than implementing a construct this unusual especially as
>> hunting down the incorrect cases shouldn't be difficult given proper
>> lockdep annotation.
> 
> On the second look, it looks like you're implementing proper
> percpu_rwlock semantics

Ah, nice! I didn't realize that I was actually doing what I intended
to avoid! ;-)

Looking at the implementation of lglocks, and going by Oleg's earlier
comment that we just need to replace spinlock_t with rwlock_t in them
to get percpu_rwlocks, I was horrified at the kinds of circular locking
dependencies that they would be prone to, unless used carefully.

So I devised this scheme to be safe, while still having relaxed rules.
But if *this* is what percpu_rwlocks should ideally look like,
then great! :-)

> as readers aren't supposed to induce circular
> dependency directly.

Yep, in this scheme, nobody will end up in circular dependency.

>  Can you please work with Oleg to implement
> proper percpu-rwlock and use that for CPU hotplug rather than
> implementing it inside CPU hotplug?
> 

Sure, I'd be more than happy to!
 
Regards,
Srivatsa S. Bhat

