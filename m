Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab0ETIaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 04:30:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:39678 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab0ETIaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 04:30:00 -0400
Subject: Re: [patch 3/7] softirq: avoid softirq_work_list for SCHED_SOFTIRQ
 when sent remotely
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Miller <davem@davemloft.net>, suresh.b.siddha@intel.com,
       mingo@elte.hu, tglx@linutronix.de, arjan@linux.jf.intel.com,
       venki@google.com, svaidy@linux.vnet.ibm.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, linux@dominikbrodowski.net,
       ncunningham@crca.org.au
In-Reply-To: <20100520082309.GH25951@kernel.dk>
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
	 <20100517184027.777058425@sbs-t61.sc.intel.com>
	 <1274343159.5605.13325.camel@twins>
	 <20100520.011432.209562565.davem@davemloft.net>
	 <20100520082309.GH25951@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 20 May 2010 10:29:18 +0200
Message-ID: <1274344158.5605.13394.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 10:23 +0200, Jens Axboe wrote:
> On Thu, May 20 2010, David Miller wrote:
> > From: Peter Zijlstra <peterz@infradead.org>
> > Date: Thu, 20 May 2010 10:12:39 +0200
> > 
> > > Most odd all that, Dave, Jens, what happened to all that remote_softirq
> > > stuff?
> > 
> > Nobody ended up using this remote softirq infrastructure, it can be
> > completely deleted.
> 
> What parts of it? There has been reworks of parts of the code since I
> added it, the block layer only uses __smp_call_function_single() to
> trigger remote softirqs.

Right, so __smp_call_function_single() is the normal remote ipi stuff
from kernel/smp.c, send_remote_softirq() is the pile of code in
kernel/softirq.c that uses that to tickle remote softirqs.

The 'problem' seems to be that the remote softirq code (not the ipi
bits) doesn't have any users and is quite complex and apparently
incomplete.

Suresh, would it make sense to do as Jens does and simply use
__smp_call_function_single() or do you think it still makes sense to
have a small wrapper and maybe share that with Jens?
