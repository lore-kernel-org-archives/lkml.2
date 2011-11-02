Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab1KBU3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:29:12 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37216 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab1KBU3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:29:11 -0400
Message-ID: <1320265543.12249.12.camel@js-netbook>
Subject: Re: [PATCH] Remove CLOCK_TICK_RATE from tsc code
From: John Stultz <johnstul@us.ibm.com>
To: dsaxena@plexity.net
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 02 Nov 2011 16:25:43 -0400
In-Reply-To: <20111101212507.GB31143@plexity.net>
References: <20111101212507.GB31143@plexity.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11110220-5112-0000-0000-0000019E9B8B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-01 at 14:25 -0700, Deepak Saxena wrote:
> The tsc code uses CLOCK_TICK_RATE which on x86
> is defined to just be the same as PIT_TICK_RATE.
> This patch updates the code use the later
> as we want to depecrate and remove the global
> CLOCK_TICK_RATE symbol.

So the ACTHZ issue is still at large (ie: we still want to have a better
sense of the actual HZ frequency for the jiffies clocksource, since the
irq generators will have some - possibly significant - granularity
error), but I'm fine with these cases of just using PIT_TICK_RATE or
PIT_LATCH on x86. 

I've applied these four to my tree.

thanks
-john


