Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab2DTJyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 05:54:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51140 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab2DTJyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 05:54:35 -0400
Subject: Re: [RFC 1/2] kernel patch for dump user space stack tool
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, Lin Ming <mlin@ss.pku.edu.cn>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
In-Reply-To: <1334812653.14538.29.camel@ymzhang.sh.intel.com>
References: <EE928378561BF1449699C96571234A740FCED62F@SHSMSX101.ccr.corp.intel.com>
	 <4F8F8B9E.3040107@gmail.com>
	 <1334812653.14538.29.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Apr 2012 11:54:28 +0200
Message-ID: <1334915668.2463.43.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-19 at 13:17 +0800, Yanmin Zhang wrote:
> 1) We could collect the HEX-format call chain data and /proc/XXX/maps
> of all the processes quickly, then parse them either after rebooting, or
> after the issue is reported. It could catch the scene just at the time point
> when the error happens. Our experiments shows the tool could collect the data
> of all processes within 200ms.

No you can't, ever heard of address space randomization?

> 2) The new tool won't stop the processes and have less impact on them.
> Considering a scenario of performance bottleneck investigation, statistics collection
> shouldn't have big impact on running processes. 

Maybe.. on these tiny systems you're working on most tasks will not be
runnable anyway since you only have 1 (maybe 2) cpus and what's running
is your dumper process, so most everything isn't runnable, attaching and
dumping stack of all tasks isn't really much more expensive than this.

the open/read/close you do on the proc files, along with the readdir
etc.. are system-calls just like the ptrace alternative.

> 3) It could support both i386 and x86-64. I tried pstack and it doesn't work
> with x86-64.

Yeah, and you'll need to extend it to ARM/MIPS/etc.. whereas there is
plenty of userspace around that can already work on all those platforms
-- if pstack cannot its weird, I'd think it would use all the regular
binutils muck that already supports all the platforms.

> 4) It follows /proc/XXX/stack interface and it's easy to use it.

Uhm, not so very much, see your ASLR issue. Furthermore it requires all
userspace be build with framepointers enabled -- which I think would be
a good thing anyway -- but with which reality seems to disagree.

