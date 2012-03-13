Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab2CMR2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:28:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:42901 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599Ab2CMR2y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:28:54 -0400
Message-ID: <1331659711.18960.86.camel@twins>
Subject: Re: [RFC PATCH 00/14] sched: entity load-tracking re-work
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
Cc: Paul Turner <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Robin Randhawa <Robin.Randhawa@arm.com>
Date: Tue, 13 Mar 2012 18:28:31 +0100
In-Reply-To: <20120312103927.GB25134@e103034-lin.cambridge.arm.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
	 <20120312103927.GB25134@e103034-lin.cambridge.arm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 10:39 +0000, Morten Rasmussen wrote:
> I have looked at traces of both runnable time and usage time trying to
> understand why you use runnable time as your load metric and not usage
> time which seems more intuitive. What I see is that runnable time
> depends on the total runqueue load. If you have many tasks on the
> runqueue they will wait longer and therefore have higher individual
> load_avg_contrib than they would if the were scheduled across more CPUs.
> Usage time is also affected by the number of tasks on the runqueue as
> more tasks means less CPU time. However, less usage can also just mean
> that the task does not execute very often. This would make a load
> contribution estimate based on usage time less accurate. Is this your
> reason for choosing runnable time? 

Exactly so, you cannot ever have more than 100% usage, so no matter how
many tasks you stick on a cpu, you'll never get over that 100% and thus
this is not a usable load metric.


