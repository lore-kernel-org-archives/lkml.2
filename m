Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab0JSNIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:08:31 -0400
Received: from canuck.infradead.org ([134.117.69.58]:47572 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235Ab0JSNIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:08:30 -0400
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Koki Sanagi <sanagi.koki@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        mathieu.desnoyers@efficios.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        David Miller <davem@davemloft.net>, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
In-Reply-To: <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>
References: <4C724298.4050509@jp.fujitsu.com>
	 <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>
	 <20100908112529.GA25931@elte.hu>  <1287395077.29097.1543.camel@twins>
	 <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com>
	 <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 19 Oct 2010 15:08:07 +0200
Message-ID: <1287493687.1994.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 15:00 +0200, Thomas Gleixner wrote:
> 
> With the addition of trace_softirq_raise() the softirq tracepoint got
> even more convoluted. Why the tracepoints take two pointers to assign
> an integer is beyond my comprehension.
> 
> But adding an extra case which treats the first pointer as an unsigned
> long when the second pointer is NULL including the back and forth
> type casting is just horrible.
> 
> Convert the softirq tracepoints to take a single unsigned int argument
> for the softirq vector number and fix the call sites.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de> 

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

A much needed cleanup indeed!
