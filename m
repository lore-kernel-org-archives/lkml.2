Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab2KFTvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:51:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2KFTvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:51:07 -0500
Date: Tue, 6 Nov 2012 11:51:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Shi <alex.shi@intel.com>
Cc: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, cl@linux.com, pjt@google.com
Subject: Re: [RFC PATCH 2/3] sched: power aware load balance,
Message-Id: <20121106115105.4ba6ab32.akpm@linux-foundation.org>
In-Reply-To: <1352207399-29497-3-git-send-email-alex.shi@intel.com>
References: <1352207399-29497-1-git-send-email-alex.shi@intel.com>
	<1352207399-29497-3-git-send-email-alex.shi@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Nov 2012 21:09:58 +0800
Alex Shi <alex.shi@intel.com> wrote:

> $for ((i=0; i < I; i++)) ; do while true; do : ; done & done
> 
> Checking the power consuming with a powermeter on the NHM EP.
> 	powersaving     performance
> I = 2   148w            160w
> I = 4   175w            181w
> I = 8   207w            224w
> I = 16  324w            324w
> 
> On a SNB laptop(4 cores *HT)
> 	powersaving     performance
> I = 2   28w             35w
> I = 4   38w             52w
> I = 6   44w             54w
> I = 8   56w             56w
> 
> On the SNB EP machine, when I = 16, power saved more than 100 Watts.

Confused.  According to the above table, at I=16 the EP machine saved 0
watts.  Typo in the data?


Also, that's a pretty narrow test - it's doing fork and exec at very
high frequency and things such as task placement decisions at process
startup might be affecting the results.  Also, the load will be quite
kernel-intensive, as opposed to the more typical userspace-intensive
loads.

So, please run a broader set of tests so we can see the effects?
