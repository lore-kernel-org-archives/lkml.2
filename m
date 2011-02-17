Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab1BQPev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:34:51 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:35285 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab1BQPes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:34:48 -0500
X-AuditID: b753bd60-a274aba0000001d0-61-4d5d4015e3c2
X-AuditID: b753bd60-a274aba0000001d0-61-4d5d4015e3c2
Message-ID: <4D5D4013.4070602@hitachi.com>
Date: Fri, 18 Feb 2011 00:34:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is
 for x86_64 right now)
References: <20110209200249.111932716@goodmis.org>	 <4D5D1672.6070206@hitachi.com> <1297948703.23343.907.camel@gandalf.stny.rr.com>
In-Reply-To: <1297948703.23343.907.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/02/17 22:18), Steven Rostedt wrote:
> On Thu, 2011-02-17 at 21:37 +0900, Masami Hiramatsu wrote:
> 
>> Oops! with this change, current kprobes might not be able to probe
>> the entry of functions, because that is always reserved by ftrace!
>> I think we need to have some new interface for replacing each other
>> safely...
> 
> Good point. I suspect that this wont be ready till .40 anyway. When I
> get a chance to work more an this, I'll also include patches where if
> -mfentry is activated kprobes will just hook to the mcount caller
> instead. Or ftrace itself :)

Ah, that's a good idea! :) it could be done without -mfentry too.
But is that possible to modify just one mcount entry? I also worry
about the latency of enabling/disabling one entry.

BTW, without dynamic ftrace (no code modifying), I think we don't
need to reserve mcount code, because no one modifies it.

> 
> I'm also working on making the function tracer a bit more flexible. That
> is, to let multiple clients control the dynamic trace instead of just
> one big global one.

Nice!


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
