Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab1GWHRK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 03:17:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:43838 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1GWHRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 03:17:03 -0400
Date: Sat, 23 Jul 2011 09:17:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Ben Greear <greearb@candelatech.com>,
        stable@kernel.org
Subject: Re: [patch 3/3] rtc: Limit frequency
In-Reply-To: <20110722150550.1878f069.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1107230916000.2702@ionos>
References: <20110722091011.717194327@linutronix.de> <20110722091045.537404938@linutronix.de> <20110722150550.1878f069.akpm@linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011, Andrew Morton wrote:

> On Fri, 22 Jul 2011 09:12:51 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > The RTC hrtimer is self rearming. We really need to limit the
> > frequency to something sensible.
> 
> > Cc: stable@kernel.org
> 
> Why?  What failures does the current code cause?  What effect do these
> failures have upon users?

Due to the hrtimer self rearming mode a user can DoS the machine
simply because it's starved by hrtimer events.

