Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab0GHMqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 08:46:30 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:59063 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab0GHMq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 08:46:28 -0400
Date: Thu, 8 Jul 2010 21:46:27 +0900
From: Norbert Preining <preining@logic.at>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: high power consumption in recent kernels
Message-ID: <20100708124627.GA7754@gamma.logic.tuwien.ac.at>
References: <20100706164539.GA14783@gamma.logic.tuwien.ac.at> <1278579992.1900.17.camel@laptop> <20100708045711.398d4e26@infradead.org> <1278590303.1900.91.camel@laptop> <20100708120421.GF20841@gamma.logic.tuwien.ac.at> <1278591779.1900.97.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278591779.1900.97.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Do, 08 Jul 2010, Peter Zijlstra wrote:
> Right, so that is a buggy patch, see the original discussion:
>   http://lkml.org/lkml/2010/4/26/249

Well, to me it wasn't so clear that this was buggy *for*my*system*
(core2)

> That said, we did frob something with the whole nohz thing, does the
> below cure anything:

Looks promising, reverting the old patch, adding that one, building,
running, unplugging ppower, powertop runs now since some time,
it seems that we are back to better situation:
Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 1.5%)       Turbo Mode     0.0%
C0                0.0ms ( 0.0%)         2.54 Ghz     0.0%
C1 mwait          0.0ms ( 0.0%)         1.60 Ghz     0.0%
C2 mwait          0.3ms ( 0.9%)          800 Mhz   100.0%
C6 mwait          8.5ms (97.6%)

Wakeups-from-idle per second : 139.9    interval: 15.0s
Power usage (ACPI estimate): 10.0W (8.8 hours) (long term: 1.7W,/50.9h)

Top causes for wakeups:
  32.2% ( 46.1)   [kernel scheduler] Load balancing tick
  20.4% ( 29.1)   [iwlagn] <interrupt>
  12.6% ( 18.0)   [extra timer interrupt]
   6.5% (  9.3)   [ahci] <interrupt>
   3.7% (  5.3)   [kernel core] hrtimer_start (tick_sched_timer)
   3.5% (  5.0)   syndaemon
   3.4% (  4.8)   [acpi] <interrupt>
   2.3% (  3.3)   yarssr

Power is going down to below 10W with brightness dimmed.

Thanks.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
I'm going to have a look.'
He glanced round at the others.
`Is no one going to say, "No you can't possibly, let me go
instead"?'
They all shook their heads.
`Oh well.'
                 --- Ford attempting to be heroic whilst being seiged by
                 --- Shooty and Bangbang.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
