Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab0KINoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:44:01 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35280 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab0KINoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:44:00 -0500
Date: Tue, 9 Nov 2010 14:43:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH] Greatly improve TSC calibration using a delayed
 workqueue
Message-ID: <20101109134355.GA29433@basil.fritz.box>
References: <1289003985-29060-1-git-send-email-johnstul@us.ibm.com>
 <20101107204153.GA17592@basil.fritz.box>
 <1289253887.2798.40.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289253887.2798.40.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Interesting. Thanks for pointing that out! Couldn't I just start the
> calibration after fs_initcall (when the hpet_late_init runs) to avoid
> this as well? 

Yes that probably would work.  Or use the barrier infrastructure 
in workqueue.c

> 
> > Another issue may be races against suspend, but that may be too
> > obscure.
> 
> Yea, that seems fairly obscure. Basically you'd have to suspend in the
> first second as the system came up. In that case the code will throw out
> any calibration refinement that's over 1% off of the initial boot
> calibration, so I think this is ok trade off.

It may happen with opportunistic suspend if the system boots very fast.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
