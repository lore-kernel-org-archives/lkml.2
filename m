Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab1BRUgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 15:36:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53267 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757813Ab1BRUgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 15:36:39 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=JGpTz_e83PYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=eUYy1LW8c5gH8bBhmEQA:9 a=gr28afKmA5NBbnQns8gA:7 a=v9cA-_wkCfoDotK6lS7GlsijQJoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: RE: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is
 for x86_64 right now)
From: Steven Rostedt <rostedt@goodmis.org>
To: Dominique Toupin <dominique.toupin@ericsson.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
In-Reply-To: <D58A856745AB5A47B1448181D1A8BBFA07673BC266@EUSAACMS0701.eamcs.ericsson.se>
References: <20110209200249.111932716@goodmis.org>
	 <4D5D1672.6070206@hitachi.com>
	 <1297948703.23343.907.camel@gandalf.stny.rr.com>
	 <4D5D4013.4070602@hitachi.com>
	 <1297957591.23343.921.camel@gandalf.stny.rr.com>
	 <4D5D47C0.9020206@hitachi.com>
	 <1297973501.23343.953.camel@gandalf.stny.rr.com>
	 <4D5E5BCF.1040509@hitachi.com>
	 <1298041659.23343.956.camel@gandalf.stny.rr.com>
	 <20110218151954.GA27834@Krystal>
	 <D58A856745AB5A47B1448181D1A8BBFA07673BC266@EUSAACMS0701.eamcs.ericsson.se>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 18 Feb 2011 15:36:35 -0500
Message-ID: <1298061395.23343.975.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 15:10 -0500, Dominique Toupin wrote:
> My understanding is stop_machine will stop all processors for many ms.

s/ms/us/


> Even if most of our systems are not hard real-time they are soft real-time and stopping all cores for a few ms is not allowed.
> We can stop a few threads while we are jump patching but all processors is too much for us.

I think I could hit a single ms if we enable full function tracing which
disables ~22,000 functions in one shot. But if you enable full function
tracing, the kernel can slow down quite drastically, and that would even
be more problematic than a single ms hic-up. As hackbench showed a %150
slowdown when function tracer was running.

Now the last measurements I took was a few years ago and it was on a 4
CPU box. Perhaps stop_machine() may be a bit more expensive on a 1024
CPU box.

-- Steve


