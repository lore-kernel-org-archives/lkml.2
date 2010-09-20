Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0ITR0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:26:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58692 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0ITR0t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:26:49 -0400
Subject: Re: [PATCH 2/6] Add IRQ_TIME_ACCOUNTING, finer accounting of CPU
 irq time
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>
In-Reply-To: <AANLkTi=RvqLTG84sziDTHWn6p93rKB12ePsYW6TfMdSz@mail.gmail.com>
References: <1284688596-6731-1-git-send-email-venki@google.com>
	 <1284688596-6731-3-git-send-email-venki@google.com>
	 <1284895291.2275.617.camel@laptop> <1284897666.2275.638.camel@laptop>
	 <20100920092734.3f46af9f@mschwide.boeblingen.de.ibm.com>
	 <1284974850.2275.682.camel@laptop>
	 <AANLkTi=RvqLTG84sziDTHWn6p93rKB12ePsYW6TfMdSz@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Sep 2010 19:26:39 +0200
Message-ID: <1285003599.2275.756.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 10:16 -0700, Venkatesh Pallipadi wrote:
> >> > You still do have the problem with local_bh_disable() though, since you
> >> > cannot distinguish between having bh disabled and processing softirq.
> >> >
> >> > So a hardirq that hits while you have bh disabled will inflate your
> >> > softirq time.

> >> Hmm, that bug is valid for CONFIG_VIRT_CPU_ACCOUNTING=y as well.
> >
> > And nobody ever noticed?
> >
> 
> Yes. I inherited the API from VIRT_CPU_ACCOUNTING along with this
> local_bh_disable bug. Agree that we need one extra bit to handle this
> case. I will take a stab at fixing this along with refresh of this
> patchset if no one else has beaten me to it until then. 

Make sure to only fix the softirq processing on the hardirq tail, not
the ksoftirqd one :-)
