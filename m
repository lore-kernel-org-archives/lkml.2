Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab2EBXkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 19:40:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4813 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab2EBXkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 19:40:35 -0400
X-Authority-Analysis: v=2.0 cv=N/Wr5hBB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=uEXl3daXtzsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=wI1-Dj-GET37w66_tpsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336002032.14207.52.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 6/9][RFC] kprobes: Allow probe on ftrace reserved text
 (but move it)
From: Steven Rostedt <rostedt@goodmis.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 02 May 2012 19:40:32 -0400
In-Reply-To: <y0mhavyl3kg.fsf@fche.csb>
References: <20120502192418.024103772@goodmis.org>
	 <20120502193237.321234712@goodmis.org> <y0mhavyl3kg.fsf@fche.csb>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 16:40 -0400, Frank Ch. Eigler wrote:
> rostedt wrote:
> 
> > [...]  Added KPROBE_FLAG_MOVED (as suggested by Masami) that is set
> > when the address is moved to get around an ftrace nop. [...]
> 
> Steve, perhaps my earlier comments on this got lost during the mailing
> list outage.

I saw it, but it didn't really specify what you wanted. Here's your
comment:


> I suspect Masami intended that this flag is later used during int3
> processing to subtract MCOUNT_INSN_SIZE back out from the pt_regs->ip
> during kprobe_handler() if this flag was set.

This is what I thought too, but to me it sounded like Masami could do
the work. I was just setting up a flag to make it possible.

> 
> The gist is that a KPROBE_FLAG_MOVED being set this way accomplishes
> very little since nothing is looking for that flag.  Instead, you
> should patch {arch/*}/kernel/kprobe.c kprobe_handler() to subtract
> MCOUNT_INSN_SIZE back out from pt_regs->ip if KPROBE_FLAG_MOVED was
> set.  That way, kprobes clients need do not perceive the int3 movement.

I basically thought that Masami wanted me to add the flag, and then
others could look for this and do the adjustment. I'm not the kprobes
author. I was just adding a flag that Masami and others could use to do
such updates.

I'm not sure if the adjustment is fine with everyone, as it may cause
repercussions that I don't know about. 

Perhaps that could be another patch (want to write it?)

-- Steve


