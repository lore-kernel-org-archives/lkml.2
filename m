Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab2DSSWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:22:38 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62186 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab2DSSWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:22:37 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] powerpc/8xx: Fix NR_IRQ bugs and refactor 8xx interrupt controller
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <1334617382.25353.14.camel@pasglop>
References: <1334607198-18694-1-git-send-email-grant.likely@secretlab.ca> <1334617382.25353.14.camel@pasglop>
Date: Thu, 19 Apr 2012 12:22:34 -0600
Message-Id: <20120419182234.352973E0700@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012 09:03:02 +1000, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Mon, 2012-04-16 at 14:13 -0600, Grant Likely wrote:
> > The mpc8xx driver uses a reference to NR_IRQS that is buggy.  It uses
> > NR_IRQs for the array size of the ppc_cached_irq_mask bitmap, but
> > NR_IRQs could be smaller than the number of hardware irqs that
> > ppc_cached_irq_mask tracks.
> > 
> > Also, while fixing that problem, it became apparent that the interrupt
> > controller only supports 32 interrupt numbers, but it is written as if
> > it supports multiple register banks which is more complicated.
> > 
> > This patch pulls out the buggy reference to NR_IRQs and fixes the size
> > of the ppc_cached_irq_mask to match the number of HW irqs.  It also
> > drops the now-unnecessary code since ppc_cached_irq_mask is no longer
> > an array.
> 
> Can you rename ppc_cached_irq_mask while at it ? I think it was written
> that way because it was all copy/pasted from powermac/pic.c which -does-
> need it to be an array (and has the same bugs btw) :-) 

Done; and I think I fixed the pic.c bugs in patch 2.

g.

