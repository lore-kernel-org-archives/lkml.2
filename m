Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab0HXNI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:08:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:49963 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab0HXNI1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:08:27 -0400
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time
 accounting
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: Venkatesh Pallipadi <venki@google.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Menage <menage@google.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
In-Reply-To: <20100824124726.GQ4684@balbir.in.ibm.com>
References: <1279583835-22854-1-git-send-email-venki@google.com>
	 <20100720095546.2f899e04@mschwide.boeblingen.de.ibm.com>
	 <AANLkTiktBNr3pVOHwxX3piwagtkGxHpp5TepBFS3UGhb@mail.gmail.com>
	 <20100722131239.208d9501@mschwide.boeblingen.de.ibm.com>
	 <AANLkTim==2J3Fo8Axz0yLvpfWf1bq_e0c0EYWi6y3xRe@mail.gmail.com>
	 <1282636286.2605.2307.camel@laptop>
	 <20100824080515.GK4684@balbir.in.ibm.com>
	 <1282640953.2605.2428.camel@laptop>
	 <20100824113801.GO4684@balbir.in.ibm.com>
	 <1282650835.2605.2629.camel@laptop>
	 <20100824124726.GQ4684@balbir.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 24 Aug 2010 15:08:14 +0200
Message-ID: <1282655294.2605.2716.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 18:17 +0530, Balbir Singh wrote:
> 
> "There are usecases where reporting this time against task
> or task groups or cgroups will be useful for user/administrator
> in terms of resource planning and utilization charging"

Or confusing, what happens if you attribute the IRQ overhead of a
ping-flood to your tasks?

By not providing these numbers per task/group people will have to
actually think about what it is that is causing these high irq loads and
have a chance of actually doing better than random attribution.

So no, providing random numbers on the slight chance that they might
possibly make sense for your workload doesn't seem like a sound reason
to provide them.


