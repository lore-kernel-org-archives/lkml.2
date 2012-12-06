Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab2LFEdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 23:33:03 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:45408 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab2LFEdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 23:33:01 -0500
Message-ID: <50C01F9B.1020107@linux.vnet.ibm.com>
Date: Thu, 06 Dec 2012 10:01:23 +0530
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
Subject: Re: [RFC PATCH v2 02/10] CPU hotplug: Provide APIs for "full" atomic
 readers to prevent CPU offline
References: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com> <20121205184313.3750.17752.stgit@srivatsabhat.in.ibm.com> <50BF99FA.8060109@linux.vnet.ibm.com> <50BFAF27.9060203@linux.vnet.ibm.com> <20121205205744.GB27465@mtj.dyndns.org>
In-Reply-To: <20121205205744.GB27465@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120604-5140-0000-0000-00000278C143
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2012 02:27 AM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Dec 06, 2012 at 02:01:35AM +0530, Srivatsa S. Bhat wrote:
>> Yes, that _sounds_ sufficient, but IMHO it won't be, in practice. The
>> *number* of call-sites that you need to convert from preempt_disable/enable
>> to get/put_online_cpus_atomic() won't be too many, however the *frequency*
>> of usage of those call-sites can potentially be very high.
> 
> I don't think that will be the case and, even if it is, doing it this
> way would make it difficult to tell.  The right thing to do is
> replacing stop_machine with finer grained percpu locking first.
> Refining it further should happen iff that isn't enough and there
> isn't an simpler solution.  So, let's please do the simple conversion
> first.
> 

Hmm, OK, that sounds like a good plan. So I'll drop the "light" and
"full" variants for now and work on providing a straight-forward
get/put_online_cpus_atomic() APIs.

Thank you!
 
Regards,
Srivatsa S. Bhat

