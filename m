Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2FFOhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:37:34 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:46904 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab2FFOhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:37:33 -0400
X-AuditID: b753bd60-9fe84ba000000655-f6-4fcf6b2adb49
X-AuditID: b753bd60-9fe84ba000000655-f6-4fcf6b2adb49
Message-ID: <4FCF6B27.2020008@hitachi.com>
Date: Wed, 06 Jun 2012 23:37:27 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip v2 3/9] ftrace/x86: Support SAVE_REGS feature on
 i386
References: <20120605102734.27845.43401.stgit@localhost.localdomain> <20120605102802.27845.49309.stgit@localhost.localdomain> <1338928666.13348.538.camel@gandalf.stny.rr.com> <20120605212411.GC11575@redhat.com> <1338939470.13348.541.camel@gandalf.stny.rr.com> <20120605234133.GD11575@redhat.com>
In-Reply-To: <20120605234133.GD11575@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/06 8:41), Frank Ch. Eigler wrote:
> Hi -
> 
>>> That would be the way for a kprobe to modify variables/values that
>>> happen to be in the registers.  In systemtap, for example:
>>> # stap -g -e 'probe kernel.function("foo") { $bar = 1 }'
>>
>> And why would we want to allow this?
>> Modifying variables with probes is another way to lead to disaster. [...]
>> What real world example leads to external sources modifying internal
>> core variables? With the obvious exception of rootkits.
> 
> Among others, systemtap has been successfully used for fault injection
> for development/testing, as well as band-aids for kernel security
> vulnerabilities, where a small change of state can improve the state
> of the system.  Obviously, this functionality is restricted to highly
> privileged users.

I agree with Frank. Register restoring should be done as far as the
ftrace is used for kprobes. Of course, one reason is for the fault
injection, which is very useful for debugging system failure. And
another technical reason is that we should do "optimization"
transparently. IMHO, kprobes works normally doing something,
optimized kprobes also should do so.

But if you introduce FTRACE_OPS_FL_RSTR_REGS flag for restoring
registers, it could be possible to provide corresponding flag
from kprobes side. (perhaps KPROBE_FLAG_NOMODREGS? :))

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
