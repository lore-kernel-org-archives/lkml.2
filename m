Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab1BRLp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 06:45:27 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59567 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab1BRLpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 06:45:25 -0500
X-AuditID: b753bd60-a314bba0000001d0-af-4d5e5bd2ce45
X-AuditID: b753bd60-a314bba0000001d0-af-4d5e5bd2ce45
Message-ID: <4D5E5BCF.1040509@hitachi.com>
Date: Fri, 18 Feb 2011 20:45:19 +0900
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
References: <20110209200249.111932716@goodmis.org>	 <4D5D1672.6070206@hitachi.com>	 <1297948703.23343.907.camel@gandalf.stny.rr.com>	 <4D5D4013.4070602@hitachi.com>	 <1297957591.23343.921.camel@gandalf.stny.rr.com>	 <4D5D47C0.9020206@hitachi.com> <1297973501.23343.953.camel@gandalf.stny.rr.com>
In-Reply-To: <1297973501.23343.953.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/02/18 5:11), Steven Rostedt wrote:
> On Fri, 2011-02-18 at 01:07 +0900, Masami Hiramatsu wrote:
> 
>> I just thought that frequent stop-machine is not so good from the user's
>> POV. I agree that disabled probe ignoring the call is enough.
>> Maybe, it could be done with the similar mechanism of jump optimization.
> 
> I thought jump optimization still calls stop_machine too?

Yes, but now it does batch optimization.
Even if hundreds kprobes are registered separately, jump optimization
has been done in background with a stop_machine per every 256 probes.
(Until optimizing, kprobes can use breakpoints instead)

Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
