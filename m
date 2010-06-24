Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab0FXLz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 07:55:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42342 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab0FXLz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 07:55:27 -0400
Date: Thu, 24 Jun 2010 13:55:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] irq_work
Message-ID: <20100624115520.GF578@basil.fritz.box>
References: <1277364453.3947.64.camel@yhuang-dev.sh.intel.com>
 <1277364727.1875.857.camel@laptop>
 <20100624102725.GA578@basil.fritz.box>
 <1277375409.1875.943.camel@laptop>
 <20100624105254.GB578@basil.fritz.box>
 <1277377121.1875.948.camel@laptop>
 <20100624110830.GC578@basil.fritz.box>
 <1277377852.1875.950.camel@laptop>
 <20100624112040.GD578@basil.fritz.box>
 <1277379204.1875.957.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277379204.1875.957.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 01:33:24PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-24 at 13:20 +0200, Andi Kleen wrote:
> > > softirq can't sleep either, you need a trampoline anywa
> > 
> > Not true, when you interrupt ring 3 it can sleep. You just need to make
> > sure to run on the right stack and fix up any irq counters.
> 
> But that is not softirq. That would be something like what faults do,

Yes not a classical one, but can use the same infrastructure.

> but we don't have anything else that does that.

Actually we do, audit in syscalls and scheduling in interrupts and signals 
all work this way. Probably more at some point adding more code to this
path was very popular.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
