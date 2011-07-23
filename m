Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab1GWHQG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 03:16:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:43828 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1GWHP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 03:15:58 -0400
Date: Sat, 23 Jul 2011 09:15:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Ben Greear <greearb@candelatech.com>,
        stable@kernel.org
Subject: Re: [patch 1/3] rtc: Handle errors correctly in
 rtc_irq_set_state()
In-Reply-To: <20110722150432.2370bcf2.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1107230907440.2702@ionos>
References: <20110722091011.717194327@linutronix.de> <20110722091045.403648377@linutronix.de> <20110722150432.2370bcf2.akpm@linux-foundation.org>
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

> On Fri, 22 Jul 2011 09:12:50 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > The code checks the correctness of the parameters, but unconditionally
> > arms/disarms the hrtimer.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: stable@kernel.org
> 
> The -stable maintainers will want to know why they should merge this.
> 
> The maintainers of other trees will wonder whether they should backport
> it too.
> 
> To help them make these decision we should always provide a description
> of the user-visible effects of the bug, please.

Fair enough. 

The result is that a random task might arm/disarm rtc timer and
surprise the real owner by either generating events or by stopping
them. Both undesired behaviour :)
