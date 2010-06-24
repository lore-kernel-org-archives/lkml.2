Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab0FXHcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 03:32:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55818 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab0FXHcN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 03:32:13 -0400
Subject: Re: [RFC][PATCH] irq_work
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1277364453.3947.64.camel@yhuang-dev.sh.intel.com>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	 <1277361352.1875.838.camel@laptop>
	 <1277361791.3947.11.camel@yhuang-dev.sh.intel.com>
	 <1277362073.1875.839.camel@laptop>
	 <1277362243.3947.20.camel@yhuang-dev.sh.intel.com>
	 <1277362680.1875.845.camel@laptop>
	 <1277363069.3947.30.camel@yhuang-dev.sh.intel.com>
	 <1277363993.1875.847.camel@laptop>
	 <1277364453.3947.64.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 09:32:07 +0200
Message-ID: <1277364727.1875.857.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 15:27 +0800, Huang Ying wrote:
> On Thu, 2010-06-24 at 15:19 +0800, Peter Zijlstra wrote:
> > On Thu, 2010-06-24 at 15:04 +0800, Huang Ying wrote:
> > 
> > > Yes. NMI is there from 8259 age.
> > 
> > But do we really care about such systems?
> > 
> > > That is possible. But in NO_HZ system, we have no tick to rely on.
> > 
> > Of course you have, you can delay the NO_HZ state when there's pending
> > callbacks, that's all of 1 line.
> > 
> > > soft_irq is better here, because it will be triggered for any interrupt.
> > 
> > Well, you can do the callbacks from irq_exit() as well, that's no
> > problem.
> 
> I think it is not a good idea to add overhead in such a hot path if the
> overhead can be avoided.

True, but I really don't like the softirq thing, and I really don't care
about !APIC machines, I probably couldn't buy one if I wanted to and its
not like we have good MCE support for them now, so who cares.
