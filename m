Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1JDJG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 05:06:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46640 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab1JDJGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 05:06:25 -0400
Subject: Re: [patch v2 1/2] sched: Use resched IPI to kick off the nohz idle
 balance
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        Prarit Bhargava <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Date: Tue, 04 Oct 2011 11:05:21 +0200
In-Reply-To: <20111003220934.834943260@sbsiddha-desk.sc.intel.com>
References: <20111003220934.834943260@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317719121.25926.15.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 15:09 -0700, Suresh Siddha wrote:
> +               smp_mb();
> +               /*
> +                * Use smp_send_reschedule() instead of resched_cpu().
> +                * This way we generate a sched IPI on the target cpu which
> +                * is idle. And the softirq performing nohz idle load balance
> +                * will be run before returning from the IPI.
> +                */
> +               smp_send_reschedule(ilb_cpu); 

Now the only thing missing is where the matching barrier is, does
receiving an interrupt imply a mb? If so that wants mentioning
somewhere, otherwise people will wonder how we can ever read the right
value.


