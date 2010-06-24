Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab0FXHEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 03:04:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:34090 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab0FXHEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 03:04:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,472,1272870000"; 
   d="scan'208";a="811010440"
Subject: Re: [RFC][PATCH] irq_work
From: Huang Ying <ying.huang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1277362680.1875.845.camel@laptop>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	 <1277361352.1875.838.camel@laptop>
	 <1277361791.3947.11.camel@yhuang-dev.sh.intel.com>
	 <1277362073.1875.839.camel@laptop>
	 <1277362243.3947.20.camel@yhuang-dev.sh.intel.com>
	 <1277362680.1875.845.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 15:04:29 +0800
Message-ID: <1277363069.3947.30.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 14:58 +0800, Peter Zijlstra wrote:
> On Thu, 2010-06-24 at 14:50 +0800, Huang Ying wrote:
> > On Thu, 2010-06-24 at 14:47 +0800, Peter Zijlstra wrote:
> > > On Thu, 2010-06-24 at 14:43 +0800, Huang Ying wrote:
> > > > Hi, Peter,
> > > 
> > > > I fact I uses exactly the similar method in my patches, just trigger it
> > > > with soft_irq instead of IRQ. Please take a look at
> > > > nmi_return_notifier_schedule in
> > > 
> > > But then why still use softirq? Once you have this its completely
> > > useless.
> > 
> > Some systems have no self interrupt, for example the system without
> > APIC. We need to provide a fallback for them. soft_irq can help here.
> 
> So there's systems that don't have self-ipi but do have NMI context?

Yes. NMI is there from 8259 age.

> Can't we run the callbacks from the tick or something for such legacy
> muck? I really don't like the whole softirq mess.

That is possible. But in NO_HZ system, we have no tick to rely on.
soft_irq is better here, because it will be triggered for any interrupt.

Best Regards,
Huang Ying

