Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746Ab0HFGSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 02:18:41 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42942 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab0HFGSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 02:18:38 -0400
X-AuditID: b753bd60-a5cd7ba000000a18-48-4c5ba939c158
Message-ID: <4C5BA937.5010504@hitachi.com>
Date: Fri, 06 Aug 2010 15:18:31 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
References: <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com>	 <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal>	 <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal>	 <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal>	 <1280855904.1923.675.camel@laptop> <20100803182556.GA13798@Krystal>	 <1280904410.1923.700.camel@laptop>  <20100804144539.GA4617@Krystal> <1280933788.1923.1281.camel@laptop>
In-Reply-To: <1280933788.1923.1281.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2010-08-04 at 10:45 -0400, Mathieu Desnoyers wrote:
> 
>> How do you plan to read the data concurrently with the writer overwriting the
>> data while you are reading it without corruption ?
> 
> I don't consider reading while writing (in overwrite mode) a valid case.
> 
> If you want to use overwrite, stop the writer before reading it.

For example, would you like to read system audit log always after
stop the audit?

NO, that's a most important requirement for tracers, especially for
system admins (they're the most important users of Linux) to check
the system health and catch system troubles.

For performance measurement and checking hotspot, one-shot tracing
is enough. But it's just for developers. But for the real world
computing, Linux is just an OS, users want to run their system,
middleware and applications, without troubles. But when they hit
a trouble, they wanna shoot it ASAP.
The flight recorder mode is mainly for those users.

Thank you,

-- 
Masami HIRAMATSU
2nd Research Dept.
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
