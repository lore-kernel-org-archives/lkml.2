Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab0ETINY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 04:13:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:35720 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab0ETINW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 04:13:22 -0400
Subject: Re: [patch 3/7] softirq: avoid softirq_work_list for SCHED_SOFTIRQ
 when sent remotely
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       Venkatesh Pallipadi <venki@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, ego@in.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20100517184027.777058425@sbs-t61.sc.intel.com>
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
	 <20100517184027.777058425@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 20 May 2010 10:12:39 +0200
Message-ID: <1274343159.5605.13325.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 11:27 -0700, Suresh Siddha wrote:
> plain text document attachment
> (fix_local_trigger_remote_softirq_for_sched.patch)
> There is no need to add the SCHED_SOFTIRQ work to the softirq_work_list
> when sent remotely. This is because any pending work associated with
> SCHED_SOFTIRQ need not be migrated to a new cpu when the current cpu is
> going down etc.
> 
> Also I am not sure how this softirq_work_list works for other softirqs.
> I don't see anyone removing the list entries from the softirq_work_list
> after it is handled on a remote cpu.

Most odd all that, Dave, Jens, what happened to all that remote_softirq
stuff?
