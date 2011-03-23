Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab1CWALS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 20:11:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50773 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755145Ab1CWALR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 20:11:17 -0400
Date: Wed, 23 Mar 2011 00:11:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Collins <collinsd@codeaurora.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Deadlock scenario in regulator core
Message-ID: <20110323001128.GC2529@opensource.wolfsonmicro.com>
References: <4D891C59.1030009@codeaurora.org>
 <20110322223702.GO14675@home.goodmis.org>
 <4D892C0A.1090606@codeaurora.org>
 <1300835998.14261.13.camel@gandalf.stny.rr.com>
 <4D8933A8.8080607@codeaurora.org>
 <1300838856.14261.35.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300838856.14261.35.camel@gandalf.stny.rr.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 08:07:36PM -0400, Steven Rostedt wrote:

> Note, I do not know this code well enough to say. I'm assuming that an
> rdevA on a rdevB->supply_list never has rdevB on its own
> rdevA->supply_list.

Correct.

> If this is the case, and that you only ever have a lock nesting of one,
> then sure, use the SINGLE_DEPTH_NESTING.

It'd be good if someone could update the documentation in the mutex code
so the usage were clear here - I don't want to see the locking become
any more complicated, especially not for relatively infrequently used
things like supplies.

Though we may be able to deal with this by simplifying the
implementation of supplies anyway.
