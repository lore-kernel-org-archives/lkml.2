Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0FXLId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 07:08:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58313 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab0FXLIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 07:08:31 -0400
Date: Thu, 24 Jun 2010 13:08:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] irq_work
Message-ID: <20100624110830.GC578@basil.fritz.box>
References: <1277362243.3947.20.camel@yhuang-dev.sh.intel.com>
 <1277362680.1875.845.camel@laptop>
 <1277363069.3947.30.camel@yhuang-dev.sh.intel.com>
 <1277363993.1875.847.camel@laptop>
 <1277364453.3947.64.camel@yhuang-dev.sh.intel.com>
 <1277364727.1875.857.camel@laptop>
 <20100624102725.GA578@basil.fritz.box>
 <1277375409.1875.943.camel@laptop>
 <20100624105254.GB578@basil.fritz.box>
 <1277377121.1875.948.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277377121.1875.948.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And I really want hardirq context for perf callbacks, some code actually
> relies on it (I used to have the fallback in the timer softirq and that

Surely that could be fixed?  *requiring* hard irq context sounds weird.

> broke thing at some point).

I have one case that needs to sleep (but only when interrupting user code)
They key thing in it really is to switch stacks back to process.

-andi
-- 
ak@linux.intel.com -- Speaking for myself only.
