Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3ADEnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 23:43:49 -0500
Received: from gate.crashing.org ([63.228.1.57]:52321 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab3ADEnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 23:43:47 -0500
Message-ID: <1357274575.2500.23.camel@pasglop>
Subject: Re: [PATCH v2 1/4] kprobes/powerpc: Do not disable External
 interrupts during single step
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, bigeasy@linutronix.de,
        oleg@redhat.com, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, anton@redhat.com, mingo@elte.hu
Date: Fri, 04 Jan 2013 15:42:55 +1100
In-Reply-To: <50C6C930.90206@in.ibm.com>
References: <20121203150438.7727.74924.stgit@suzukikp>
	 <20121203150720.7727.91582.stgit@suzukikp> <50C6C930.90206@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 11:18 +0530, Suzuki K. Poulose wrote:
> On 12/03/2012 08:37 PM, Suzuki K. Poulose wrote:
> > From: Suzuki K. Poulose <suzuki@in.ibm.com>
> >
> > External/Decrement exceptions have lower priority than the Debug Exception.
> > So, we don't have to disable the External interrupts before a single step.
> > However, on BookE, Critical Input Exception(CE) has higher priority than a
> > Debug Exception. Hence we mask them.

I'm not sure about that one ...

>From memory, 4xx has that interesting issue which is that if you have
single step enabled and an interrupt (of *any kind* occurs), the
processor *will* step into the first instruction of the interrupt
handler. (In fact, some silicons have a bug where it can even be the
*second* instruction of the handler, which can be problematic when the
first one is a branch).

This is why you may notice that whole business we have in the handling
of debug/crit interrupts where we try to figure out if that happened,
and return with DE off if it did.

Now, the above mentioned workaround means we might not need to disable
EE indeed.

However, in any case, I don't see what your patch fixes or improves, nor
do I understand what you mean by "it is possible we'd get the single
step reported for CE". Please explain in more details and describe the
problematic scenario.

Cheers,
Ben.


