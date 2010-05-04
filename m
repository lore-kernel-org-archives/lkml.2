Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab0EDHkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 03:40:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50123 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab0EDHkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 03:40:52 -0400
Subject: Re: [PATCH 3/3] alpha: Implement HW performance events on the EV67
 and later CPUs.
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-alpha@vger.kernel.org
In-Reply-To: <8e86ca502b675b3730bd58be391e0239e87e176d.1272668361.git.mcree@orcon.net.nz>
References: <cover.1272668360.git.mcree@orcon.net.nz>
	 <8e86ca502b675b3730bd58be391e0239e87e176d.1272668361.git.mcree@orcon.net.nz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 May 2010 09:40:08 +0200
Message-ID: <1272958808.5605.126.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-01 at 11:55 +1200, Michael Cree wrote:
> +/* I wonder what this is for ??? */
> +void set_perf_event_pending(void)
> +{
> +} 

If the PMU Interrupt comes in as an NMI we cannot take locks and such
from its handler. So what we do is queue that work to be ran later. The
kernel has a fallback to run this stuff from the timer hardirq, but if
the PMI is IRQ context (like ARM) you can simply call
perf_event_do_pending() at its tail.

Alternatively you can self-IPI like x86 does and run
perf_event_do_pending() from there.


