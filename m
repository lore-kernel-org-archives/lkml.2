Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab0JAXOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 19:14:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:44458 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab0JAXOs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 19:14:48 -0400
Subject: Re: [PATCH 3/7] Add IRQ_TIME_ACCOUNTING, finer accounting of irq
 time -v3
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <AANLkTi=b2NaXOS05tT69hdmddxPPc5OxxnZ0qG0ZZZYe@mail.gmail.com>
References: <1285788096-29471-1-git-send-email-venki@google.com>
	 <1285788096-29471-4-git-send-email-venki@google.com>
	 <1285844768.2144.11.camel@laptop>
	 <AANLkTi=r5DX52+735OtGHmJCS38n1P_WxEkKzLVf1E_m@mail.gmail.com>
	 <AANLkTikHfyjjZfDcoO-yDW+JTnpDb42VxRMckk55Xp+O@mail.gmail.com>
	 <1285933569.2144.57.camel@laptop>
	 <AANLkTinmgCmozNMQyesaTxrAfzgJ7bKEAeyNRWh7ceZ5@mail.gmail.com>
	 <AANLkTi=b2NaXOS05tT69hdmddxPPc5OxxnZ0qG0ZZZYe@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 02 Oct 2010 01:14:33 +0200
Message-ID: <1285974873.2144.65.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 10:29 -0700, Venkatesh Pallipadi wrote:
> So, on x86, sched_clock_stable is not set on all other kind of CPUs
> and my test system happens to be one of them. So, sched_clock_cpu()
> falls back to tick based even when TSC is not marked unstable and
> clocksource is using TSC for timing. 

It is never tick based!! It's tick augmented! Because TSC is such a
piece of crap we use external (slow) means of determining a window in
which the TSC should live and then use the TSC to generate high
resolution offsets inside that.

So even if your usage is in the hardirq context that moves that window
it should all work out.
