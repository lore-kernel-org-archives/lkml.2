Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab1JCKZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 06:25:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:49708 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab1JCKYx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:24:53 -0400
Subject: Re: [RFC][PATCH 1/3] sched: Provide delayed wakeup list
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
Date: Mon, 03 Oct 2011 12:23:57 +0200
In-Reply-To: <4E886ED5.8060407@colorfullife.com>
References: <20110914133034.687048806@chello.nl>
	 <20110914133750.739484417@chello.nl> <4E886ED5.8060407@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317637437.20367.9.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-02 at 16:01 +0200, Manfred Spraul wrote:
> Do you still work on the wake_up_list() patch?

I plan to, but I got a little side tracked. We need to ensure all
schedule() callers can deal with spurious wakeups. To that end I talked
to the smatch author who kindly provided a test for this, but I still
need to actually run it and see how bad the fallout is and fix stuff up.

All core primitives 'should' be good, but there's a lot of shady stuff
out there that isn't.


