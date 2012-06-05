Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab2FELsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:48:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13424 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab2FELsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:48:50 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=uAhdh18vUBcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=T9LnYHywt4ANgGyR_lcA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338896927.13348.536.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH -tip v2 0/9]ftrace,kprobes: Ftrace-based kprobe
 optimization
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Tue, 05 Jun 2012 07:48:47 -0400
In-Reply-To: <20120605102734.27845.43401.stgit@localhost.localdomain>
References: <20120605102734.27845.43401.stgit@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 19:27 +0900, Masami Hiramatsu wrote:
> Hi Steven,
> 
> Here is the version 2 patches for kprobe-ftrace. Since I didn't
> touch ftrace part in this version, old gcc bug still be there.
> So, if you have another implementation, prease replace former 3
> patches in this series with your patch.
> 

Thanks Masami,

I'll be incorporating these patches into my own set, and see how they
fit. I would have had more done yesterday, but I'm also testing against
PPC and discovered a bug in the PPC function tracing and was side
tracked in fixing it (ended up being a new function that had to be
tagged with 'notrace').


> ftrace_ops.regs_func is still under discussion because older
> gcc doesn't support initalizing unnamed union member.

Right, I working on adding the ops and regs parameters for all users,
and working on making sure this work for other archs. I'll be testing
against i386, x86_64, PPC64, PPC32, and ARM (snowball board, and this is
the perfect excuse for me to get my panda board running too :-)

Thanks!

-- Steve

> 
> In this version, I've removed notrace dependency from __kprobes.
> Instead, it just set filter correctly before adding ftrace_ops
> not to trace all functions.
> 
> Changes in v2:
>  - Fix ftrace_ops registering right after setting its filter.
>  - Unregister ftrace_ops if there is no kprobe useing.
>  - Remove notrace dependency from __kprobes macro.
> 


