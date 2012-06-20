Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab2FTRih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:38:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:35781 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986Ab2FTRig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:38:36 -0400
Message-ID: <1340213901.21745.122.camel@twins>
Subject: Re: [PATCH v3] sched: balance_cpu to consider other cpus in its
 group as target of (pinned) task
From: Peter Zijlstra <peterz@infradead.org>
To: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Cc: mingo@kernel.org, LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, efault@gmx.de,
        Ingo Molnar <mingo@elte.hu>
Date: Wed, 20 Jun 2012 19:38:21 +0200
In-Reply-To: <4FE06CDB.2060605@linux.vnet.ibm.com>
References: <4FE06CDB.2060605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 17:43 +0530, Prashanth Nageshappa wrote:
> T2 will starve eternally in this case. The same
> scenario can arise in presence of non-rt tasks as well (say we replace F1 with
> high irq load or with a very high priority SCHED_OTHER task that can't move out
> of C2). 

Uhm, no. In the case where both F1 and T2 are SCHED_OTHER starvation is
impossible.

What can happen with pure SCHED_OTHER affinities is being less fair than
desired.

Anyway, I took the patch with a few minor edits -- ie. we don't need to
reset loop_break, its never changed (same for the ALL_PINNED patch you
sent).


