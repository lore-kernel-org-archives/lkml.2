Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab0ILS5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:57:19 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:52635 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab0ILS5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:57:16 -0400
Date: Sun, 12 Sep 2010 20:57:15 +0200
From: Andreas Mohr <andi@lisas.de>
To: Louis-David Mitterrand <vindex+lists-linux-kernel@apartia.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ksoftirqd/n permanently eating 60% of a CPU
Message-ID: <20100912185715.GA8775@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100912154138.GA23554@apartia.fr>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Examining /proc/interrupts shows that "Local timer interrupts" are
> mainly firing.

> Strangely enough, the interrupt storm starts only 5 minutes or so after
> bootup.

So you're saying that the exact change in behaviour after 5 minutes
is a much increased local interrupt activity?


Something that might help in nailing down the source of the CPU load
is doing an oprofile trace (for contexts that aren't in interrupt-off periods, that is).


If it's in fact a local interrupt issue, then people such as Gleixner
or Stultz (timers) or Molnar (APIC) might know further details, IIRC.

And have you tried running powertop or manually (perhaps via sophisticated shell
script) keeping a watch on /proc/timer[list|stats]?

Andreas Mohr
