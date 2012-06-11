Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab2FKNS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 09:18:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab2FKNSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 09:18:23 -0400
Date: Mon, 11 Jun 2012 09:18:04 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, joe@perches.com,
        mingo@elte.hu, nzimmer@sgi.com, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: + nmi-watchdog-quiet-down-the-boot-messages.patch added to -mm
 tree
Message-ID: <20120611131804.GX32472@redhat.com>
References: <20120608213709.B320BA022F@akpm.mtv.corp.google.com>
 <20120611084744.GH31556@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120611084744.GH31556@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 10:47:44AM +0200, Ingo Molnar wrote:
> >     NMI watchdog enabled, takes one hw-pmu counter.
> >     Booting Node   0, Processors  #1
> >     NMI watchdog enabled, takes one hw-pmu counter.
> >      #2
> >     NMI watchdog enabled, takes one hw-pmu counter.
> >      #3 Ok.
> >     NMI watchdog enabled, takes one hw-pmu counter.
> >     Brought up 4 CPUs
> >     Total of 4 processors activated (22607.24 BogoMIPS).
> 
> the problem really was that it didn't print which CPU it 
> referred to - it just repeated the same message over and over 
> again.
> 
> If it said:
> 
>      NMI watchdog enabled on CPU#0, takes one hw-pmu counter.
> 
> it would be far less confusing.

Sure.  The problem SGI has with 4096 cpus is the volume.  Specifying which
cpu the message belongs to, I do not think helps with this problem.

> 
> This:
> 
> > After the change, it is simplified to:
> > 
> >     ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> >     CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
> >     Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
> >     ... version:                2
> >     ... bit width:              40
> >     ... generic registers:      2
> >     ... value mask:             000000ffffffffff
> >     ... max period:             000000007fffffff
> >     ... fixed-purpose events:   3
> >     ... event mask:             0000000700000003
> >     NMI watchdog enabled, takes one hw-pmu counter.
> >     Booting Node   0, Processors  #1 #2 #3 Ok.
> >     Brought up 4 CPUs
> 
> Is fine too but should be clarified to something like:
> 
>      NMI watchdog enabled on all CPUs, permanently consumes one hw-PMU counter
> 
> (Please note the capitalization of 'PMU' as well.)

Ok.  I can modify that.

Cheers,
Don
