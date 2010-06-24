Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0FXG61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 02:58:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:56336 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab0FXG60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 02:58:26 -0400
Subject: Re: [RFC][PATCH] irq_work
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1277362243.3947.20.camel@yhuang-dev.sh.intel.com>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	 <1277361352.1875.838.camel@laptop>
	 <1277361791.3947.11.camel@yhuang-dev.sh.intel.com>
	 <1277362073.1875.839.camel@laptop>
	 <1277362243.3947.20.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 08:58:00 +0200
Message-ID: <1277362680.1875.845.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 14:50 +0800, Huang Ying wrote:
> On Thu, 2010-06-24 at 14:47 +0800, Peter Zijlstra wrote:
> > On Thu, 2010-06-24 at 14:43 +0800, Huang Ying wrote:
> > > Hi, Peter,
> > 
> > > I fact I uses exactly the similar method in my patches, just trigger it
> > > with soft_irq instead of IRQ. Please take a look at
> > > nmi_return_notifier_schedule in
> > 
> > But then why still use softirq? Once you have this its completely
> > useless.
> 
> Some systems have no self interrupt, for example the system without
> APIC. We need to provide a fallback for them. soft_irq can help here.

So there's systems that don't have self-ipi but do have NMI context?

Can't we run the callbacks from the tick or something for such legacy
muck? I really don't like the whole softirq mess.
