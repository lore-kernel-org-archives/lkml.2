Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423747Ab2LGSQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 13:16:18 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38305 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423669Ab2LGSQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 13:16:15 -0500
Date: Fri, 7 Dec 2012 10:16:08 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, oleg@redhat.com,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/9] CPU hotplug: Provide APIs to prevent CPU
 offline from atomic context
Message-ID: <20121207181608.GB2821@htj.dyndns.org>
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com>
 <20121207173759.27305.84316.stgit@srivatsabhat.in.ibm.com>
 <20121207175724.GA2821@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207175724.GA2821@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Fri, Dec 07, 2012 at 09:57:24AM -0800, Tejun Heo wrote:
> possible.  Also, I think the right approach would be auditing each
> get_online_cpus_atomic() callsites and figure out proper locking order
> rather than implementing a construct this unusual especially as
> hunting down the incorrect cases shouldn't be difficult given proper
> lockdep annotation.

On the second look, it looks like you're implementing proper
percpu_rwlock semantics as readers aren't supposed to induce circular
dependency directly.  Can you please work with Oleg to implement
proper percpu-rwlock and use that for CPU hotplug rather than
implementing it inside CPU hotplug?

Thanks.

-- 
tejun
