Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0I3G7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 02:59:10 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:54543 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab0I3G7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:59:09 -0400
Date: Thu, 30 Sep 2010 15:59:02 +0900
From: Norbert Preining <preining@logic.at>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "efault@gmx.de" <efault@gmx.de>, "Li, Shaohua" <shaohua.li@intel.com>,
        tglx <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhao, Yakui" <yakui.zhao@intel.com>
Subject: Re: high power consumption in recent kernels
Message-ID: <20100930065902.GC15882@gamma.logic.tuwien.ac.at>
References: <EA929A9653AAE14F841771FB1DE5A1366008738EC2@rrsmsx501.amr.corp.intel.com> <20100909205115.GD11053@gamma.logic.tuwien.ac.at> <1284107099.402.30.camel@laptop> <6E3BC7F7C9A4BF4286DD4C043110F30B2991AF14FD@shsmsx502.ccr.corp.intel.com> <20100910145451.GB21450@gamma.logic.tuwien.ac.at> <1284355277.26157.8109.camel@debian> <20100922154452.GA9080@gamma.logic.tuwien.ac.at> <1285670426.21962.43.camel@debian> <4CA34F95.30400@logic.at> <1285807841.21962.1147.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285807841.21962.1147.camel@debian>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The following line is different, the new code remove the nohz_ratelimit
> from irq_exit(). That may resolve your system too many interrupts
> issue. 
> 
> +               arch_needs_cpu(cpu)|| (inidle && nohz_ratelimit(cpu))) {

That is a very nice one ..., first time I came down
with inactive laptop, lowest brightness, down to below 8W:
Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 1.1%)       Turbo Mode     0.0%
C0                0.0ms ( 0.0%)         2.54 Ghz     0.0%
C1 mwait          0.0ms ( 0.0%)         1.60 Ghz     0.0%
C2 mwait          0.3ms ( 0.8%)          800 Mhz    99.9%
C6 mwait         16.7ms (98.2%)

Wakeups-from-idle per second : 81.3     interval: 15.0s
Power usage (ACPI estimate): 7.9W (11.0 hours)

Top causes for wakeups:
  23.8% ( 18.1)   kworker/0:0
  14.0% ( 10.7)   [ahci] <interrupt>
  13.4% ( 10.2)   [kernel scheduler] Load balancing tick
   6.6% (  5.0)   syndaemon
   5.5% (  4.2)   Xorg
   5.5% (  4.2)   [extra timer interrupt]
   4.6% (  3.5)   [acpi] <interrupt>

Very nice, with activity and bluetooth and internet over bluetooth
I am back at 10.3W, but that is also fine.

Anything else you need to know (kernel was latest git, -rc6 AFAIR).

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
The main reception foyer was almost empty but Ford
nevertheless weaved his way through it.
                 --- Ford making his way out of Milliways whilst under the
                 --- influence of enough alchol to make a rhino sing.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
