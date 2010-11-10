Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab0KJNrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 08:47:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36464 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab0KJNrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 08:47:05 -0500
Date: Wed, 10 Nov 2010 14:47:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH] Greatly improve TSC calibration using a delayed
 workqueue
Message-ID: <20101110134700.GB7205@basil.fritz.box>
References: <1289003985-29060-1-git-send-email-johnstul@us.ibm.com>
 <20101107204153.GA17592@basil.fritz.box>
 <1289253887.2798.40.camel@localhost.localdomain>
 <20101109134355.GA29433@basil.fritz.box>
 <1289338900.9434.51.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289338900.9434.51.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 01:41:40PM -0800, john stultz wrote:
> > It may happen with opportunistic suspend if the system boots very fast.
> 
> Right, but a system using opportunistic suspend will have a hard enough
> time keeping close NTP sync on its own given the frequent switching
> between the fine-grained ntp adjusted clocksource during run-time and
> the coarse non-adjusted RTC/persisitent_clock while suspended.
> 
> So I think such a system would be fine it falls back to using just the
> boot-calibration for TSC freq rather then the refined calibration freq
> calculated by this patch (which will happen automatically if the refined
> calibration is off by 1%).
> 
> Does that seem like a reasonable tradeoff?

Yes it sounds good to me.  Some inaccuracy in this case is fine I guess.
Just major inaccuracy or a crash or hang wouldn't be good.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
