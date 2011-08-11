Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1HKDXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 23:23:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39024 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1HKDX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 23:23:29 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=4Stzp0-EpPcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=tcGCEW8-2yqL9dmH9McA:9 a=b9hHhNdkK1YoWnzfdfMA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH][3.0] Tracepoint: dissociate from module mutex (v2)
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        yrl.pp-manager.tt@hitachi.com
In-Reply-To: <4E434928.9020304@hitachi.com>
References: <20110810191839.GC8525@Krystal>  <4E434928.9020304@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Aug 2011 23:23:27 -0400
Message-ID: <1313033007.18583.283.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 12:14 +0900, Masami Hiramatsu wrote:
> (2011/08/11 4:18), Mathieu Desnoyers wrote:
> > Copy the information needed from struct module into a local module list
> > held within tracepoint.c from within the module coming/going notifier.
> > 
> > This vastly simplifies locking of tracepoint registration /
> > unregistration, because we don't have to take the module mutex to
> > register and unregister tracepoints anymore. Steven Rostedt ran into
> > dependency problems related to modules mutex vs kprobes mutex vs ftrace
> > mutex vs tracepoint mutex that seems to be hard to fix without removing
> > this dependency between tracepoint and module mutex. (note: it should be
> > investigated whether kprobes could benefit of being dissociated from the
> > modules mutex too.)
> 
> Thanks, it seems that kprobes has already mostly done that.
> It holds module_mutex only in kprobe_optimizer. However,
> it seems meaningless, because kprobe_mutex already protects
> kprobe_optimizer against the kprobes module notifier.
> Thus, a module removing will stays on the notifier until
> the optimizer runs out. So I think we can remove that mutex lock.
> 

So should I change my patch 4/5 to just remove the module_mutex?

[PATCH 4/5][RFC] kprobes: Inverse taking of module_mutex with kprobe_mutex

-- Steve


