Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab0FXLdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 07:33:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50723 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab0FXLda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 07:33:30 -0400
Subject: Re: [RFC][PATCH] irq_work
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H.PeterA" <"nvin hpa"@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100624112040.GD578@basil.fritz.box>
References: <1277363069.3947.30.camel@yhuang-dev.sh.intel.com>
	 <1277363993.1875.847.camel@laptop>
	 <1277364453.3947.64.camel@yhuang-dev.sh.intel.com>
	 <1277364727.1875.857.camel@laptop> <20100624102725.GA578@basil.fritz.box>
	 <1277375409.1875.943.camel@laptop> <20100624105254.GB578@basil.fritz.box>
	 <1277377121.1875.948.camel@laptop> <20100624110830.GC578@basil.fritz.box>
	 <1277377852.1875.950.camel@laptop>  <20100624112040.GD578@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 13:33:24 +0200
Message-ID: <1277379204.1875.957.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 13:20 +0200, Andi Kleen wrote:
> > softirq can't sleep either, you need a trampoline anywa
> 
> Not true, when you interrupt ring 3 it can sleep. You just need to make
> sure to run on the right stack and fix up any irq counters.

But that is not softirq. That would be something like what faults do,
but we don't have anything else that does that.


