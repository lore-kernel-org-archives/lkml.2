Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab0KIVl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:41:59 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:40544 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab0KIVlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:41:55 -0500
Subject: Re: [PATCH] Greatly improve TSC calibration using a delayed
 workqueue
From: john stultz <johnstul@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Clark Williams <williams@redhat.com>
In-Reply-To: <20101109134355.GA29433@basil.fritz.box>
References: <1289003985-29060-1-git-send-email-johnstul@us.ibm.com>
	 <20101107204153.GA17592@basil.fritz.box>
	 <1289253887.2798.40.camel@localhost.localdomain>
	 <20101109134355.GA29433@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 13:41:40 -0800
Message-ID: <1289338900.9434.51.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 14:43 +0100, Andi Kleen wrote:
> > Interesting. Thanks for pointing that out! Couldn't I just start the
> > calibration after fs_initcall (when the hpet_late_init runs) to avoid
> > this as well? 
> 
> Yes that probably would work.  Or use the barrier infrastructure 
> in workqueue.c
> 
> > 
> > > Another issue may be races against suspend, but that may be too
> > > obscure.
> > 
> > Yea, that seems fairly obscure. Basically you'd have to suspend in the
> > first second as the system came up. In that case the code will throw out
> > any calibration refinement that's over 1% off of the initial boot
> > calibration, so I think this is ok trade off.
> 
> It may happen with opportunistic suspend if the system boots very fast.

Right, but a system using opportunistic suspend will have a hard enough
time keeping close NTP sync on its own given the frequent switching
between the fine-grained ntp adjusted clocksource during run-time and
the coarse non-adjusted RTC/persisitent_clock while suspended.

So I think such a system would be fine it falls back to using just the
boot-calibration for TSC freq rather then the refined calibration freq
calculated by this patch (which will happen automatically if the refined
calibration is off by 1%).

Does that seem like a reasonable tradeoff?

thanks
-john



