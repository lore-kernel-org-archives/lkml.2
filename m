Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213Ab2COKqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:46:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47105 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab2COKqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:46:43 -0400
Message-ID: <1331808391.18960.160.camel@twins>
Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
From: Peter Zijlstra <peterz@infradead.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Date: Thu, 15 Mar 2012 11:46:31 +0100
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A056F47@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
	 <1331546307.18960.26.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A054D70@SHSMSX101.ccr.corp.intel.com>
	 <1331654251.18960.78.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A0556FA@SHSMSX101.ccr.corp.intel.com>
	 <1331718197.18960.106.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A056F47@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 00:11 +0000, Liu, Chuansheng wrote:
> 
> > -----Original Message-----
> > From: Peter Zijlstra [mailto:peterz@infradead.org]
> > Sent: Wednesday, March 14, 2012 5:43 PM
> > To: Liu, Chuansheng
> > Cc: linux-kernel@vger.kernel.org; Yanmin Zhang; tglx@linutronix.de
> > Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
> > 
> > On Wed, 2012-03-14 at 06:27 +0000, Liu, Chuansheng wrote:
> > > On the unplug case, after set the CPU to !active, we do not need IPI
> > > handling for the corresponding CPU before it is set to offline. I did
> > > not find any impact that limiting the smp_call_function just after CPU
> > > is active.
> > 
> > Have a look at Alpha, it's flush_tlb_mm() can use smp_call_function(), in
> > the !active,online case you very much still need to tlb flush that cpu.
> > 
> > The fact that it works on a limited use case on x86 doesn't say anything much
> > at all.

> Thanks your pointing out, do you have any other perfect solution for this issue?
> As for the stress test result, advancing the setting active before setting online broken
> something either.

I'm not sure I understand.. are you saying that commit
5fbd036b552f633abb394a319f7c62a5c86a9cd7 in tip/master broke something?
