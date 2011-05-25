Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab1EYKsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 06:48:13 -0400
Received: from mail4.comsite.net ([205.238.176.238]:5979 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab1EYKsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 06:48:12 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
To: Thomas Gleixner <tglx@linutronix.de>
From: Milton Miller <miltonm@bga.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] irq: radix_tree_insert can fail
In-Reply-To: <alpine.LFD.2.02.1105251017460.3078@ionos>
Message-ID: <radix-insert-can-fail-reply1@mdm.bga.com>
References: <generic-irq-changes@mdm.bga.com>
	<radix-insert-can-fail@mdm.bga.com>
	 <alpine.LFD.2.02.1105251017460.3078@ionos>
Date: Wed, 25 May 2011 05:48:11 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 about 10:18:40 +0200 (CEST), Thomas Gleixner wrote:
> On Wed, 25 May 2011, Milton Miller wrote:
> 
> > Check the insert, and if it fails cleanup and free all partial work.
> > 
> > Sparse irq was not checking the return code from radix_tree_insert,
> > but it may need to allocate memory and can fail.  If it failed,
> > it still claimed success to the caller but the affected irq(s) are
> > unavailable and the reference to the affected descriptors is leaked.
> > 
> > Signed-off-by: Milton Miller <miltonm@bga.com>
> > ---
> > I started by tring to change free_desc to take the descriptor pointer
> > and pushing that down, but that soon ran into conflicts between the
> > array and sparse implementations, and/or the old dynamic irq cleanup
> > function that is still used by some architectures.  This version is
> > targeted, and also protects against scribbles to irq_data.irq.
> 
> The simpler solution is to move irq_insert_desc() into alloc_desc()
> and deal with the error case there.

And I see that this one too as written does not compile, due to
my faulty config testing.  I'll explore your idea tomorrow after
some sleep, but it makes sense.

milton
