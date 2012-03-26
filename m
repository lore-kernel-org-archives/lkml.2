Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab2CZTs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 15:48:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44347 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab2CZTs5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 15:48:57 -0400
Message-ID: <1332785212.16159.170.camel@twins>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Peter Zijlstra <peterz@infradead.org>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Date: Mon, 26 Mar 2012 20:06:52 +0200
In-Reply-To: <20120326173533.GA4689@linux.vnet.ibm.com>
References: <1329764866.2293.376.camhel@twins>
	 <20120305152443.GE26559@linux.vnet.ibm.com>
	 <20120306091410.GD27238@elte.hu>
	 <20120322153205.GA28570@linux.vnet.ibm.com>
	 <1332750960.16159.81.camel@twins>
	 <20120326173533.GA4689@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 23:05 +0530, Srivatsa Vaddagiri wrote:
> 
> From what I can tell, the huge improvement in benchmark score is coming from 
> reduced latencies for its VM tasks. 

But if the machine is pegged latency should not impact throughput (since
there's always work to do), so are you creating extra idle time some
place?

Are you running against lock-inversion in the vcpus? Or that tlb
shootdown issue we had in the gang scheduling thread? Both are typically
busy-wait time, which is of course harder to spot that actual idle
time :/

Then again, reducing latency is good, so I don't object to that per-se,
but that flips the question, why does it regress those other loads?

The biggest regression came from tbench, wasn't that mostly a random
number generator anyway? How stable are those results, do you have a
variance measure on the results?
