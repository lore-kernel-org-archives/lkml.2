Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab2LKNsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:48:08 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45407 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab2LKNsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:48:06 -0500
Date: Tue, 11 Dec 2012 05:47:58 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, tglx@linutronix.de, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org,
        vincent.guittot@linaro.org, sbw@mit.edu, amit.kucheria@linaro.org,
        rostedt@goodmis.org, rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/9] CPU hotplug: Provide APIs to prevent CPU
 offline from atomic context
Message-ID: <20121211134758.GA7084@htj.dyndns.org>
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com>
 <20121207173759.27305.84316.stgit@srivatsabhat.in.ibm.com>
 <20121209191437.GA2816@redhat.com>
 <50C4EB79.5050203@linux.vnet.ibm.com>
 <20121209202234.GA5793@redhat.com>
 <50C564ED.9090803@linux.vnet.ibm.com>
 <20121210172410.GA28479@redhat.com>
 <50C73192.9010905@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C73192.9010905@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Srivatsa.

On Tue, Dec 11, 2012 at 06:43:54PM +0530, Srivatsa S. Bhat wrote:
> This approach (of using synchronize_sched()) also looks good. It is simple,
> yet effective, but unfortunately inefficient at the writer side (because
> he'll have to wait for a full synchronize_sched()).

While synchornize_sched() is heavier on the writer side than the
originally posted version, it doesn't stall the whole machine and
wouldn't introduce latencies to others.  Shouldn't that be enough?

Thanks.

-- 
tejun
