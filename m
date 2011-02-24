Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab1BXVXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:23:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:34834 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565Ab1BXVXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:23:43 -0500
Subject: Re: PowerPC BUG: using smp_processor_id() in preemptible code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hughd@google.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <1298581675.5226.840.camel@laptop>
References: <alpine.LSU.2.00.1012291413360.22939@sister.anvils>
	 <1293705910.17779.60.camel@pasglop>
	 <alpine.LSU.2.00.1102241216420.1708@sister.anvils>
	 <1298581675.5226.840.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 08:23:26 +1100
Message-ID: <1298582606.8833.509.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 22:07 +0100, Peter Zijlstra wrote:
> 
> Lovely problem :-), benh mentioned it on IRC, but I never got around
> to
> finding the email thread, thanks for the CC.
> 
> > What would be better for 2.6.38 and 2.6.37-stable?  Moving that call
> to
> > vunmap_page_range back under vb->lock, or the partial-Peter-patch
> below?
> > And then what should be done for 2.6.39?
> 
> I think you'll also need the arch/powerpc/kernel/process.c changes
> that
> cause context switches to flush the tlb_batch queues.

I don't think that's needed here as there shall be no batching happening
on the vmalloc space, but it can't hurt to merge it regardless :-)

Cheers,
Ben.

