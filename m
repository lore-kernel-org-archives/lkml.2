Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab2EDUwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:52:15 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:35901 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759955Ab2EDUwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:52:10 -0400
Date: Fri, 4 May 2012 13:49:08 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets
 handling upon CPU hotplug
Message-ID: <20120504204908.GC18177@linux.vnet.ibm.com>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
 <1336159496.6509.51.camel@twins>
 <4FA434E9.6000305@linux.vnet.ibm.com>
 <1336162456.6509.63.camel@twins>
 <1336163281.6509.69.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336163281.6509.69.camel@twins>
X-Operating-System: Linux 3.2.0-24-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050420-4242-0000-0000-0000018FC92E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.05.2012 [22:28:01 +0200], Peter Zijlstra wrote:
> On Fri, 2012-05-04 at 22:14 +0200, Peter Zijlstra wrote:
> > > Also, we need to fix this problem at the CPU Hotplug level itself, and
> > > not just for the suspend/resume case. Because, we have had numerous bug
> > > reports and people complaining about this issue, in various scenarios,
> > > including those that didn't involve suspend/resume.
> > 
> > NO, absolutely not and I will NAK any and all such nonsense. WTF is a
> > cpuset worth if you can run on random other cpus? 
> 
> Sorting your cpuset 'problem' isn't nowhere near enough to make hotplug
> 'safe'. unplug also destroys task_struct::cpus_allowed.
> 
> Try it:
> 
>  # schedtool -a 2 $$
>  # grep Cpus_allowed /proc/self/status
>  Cpus_allowed:   000004
>  # echo 0 > /sys/devices/system/cpu/cpu2/online
>  # grep Cpus_allowed /proc/self/status
>  Cpus_allowed:   ffffff
> 
> 
> See, hotplug is destructive, it has to be, there's no saying the cpu
> will every come back.

I think it's ok for hotplug to be destructive. But I guess I'm not
entirely sure why cpusets can't retain user-inputted
configuration/policy information even while destroying things currently?
And re-instating that policy if possible in the future?

> So mucking about trying to make cpusets non-destructive is pointless.
> 
> The real bug is people using hotplug (for all kinds of stupid stuff) and
> expecting anything different.

Probably true :)

-Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center

