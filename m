Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab1EZF0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:26:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49337 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab1EZF0J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:26:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=YYx7FapZ+ImBllI+TXcQ65E35yHCA6FBSAh2MfULkKZDFkasgh9UHgzhMOmZ6pE5/T
         8Q91vuGCfOqNjwTOLoeYMq4+4VLT8SdfhGukvR+aFRAjNSEBecP8UtwyWkoNWGZwrVqp
         gfhBPt/eHA6iUfnUl8c9nGTSOiy9HFkKUEFCM=
MIME-Version: 1.0
In-Reply-To: <1306375622.1465.137.camel@gandalf.stny.rr.com>
References: <20110512102255.2540.88867.stgit@ltc-x64-VirtualBox> <1306375622.1465.137.camel@gandalf.stny.rr.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 26 May 2011 01:25:48 -0400
X-Google-Sender-Auth: SC_uZi0NRY1MNbJV8vsrR12UnZg
Message-ID: <BANLkTinMH_tsESVqN=dJZgpEncpYyDMHzQ@mail.gmail.com>
Subject: Re: [PATCH -tip ] [BUGFIX]tracing/kprobes: Fix kprobe-tracer to
 support stack trace
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        yrl.pp-manager.tt@hitachi.com, Russell King <rmk@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 22:07, Steven Rostedt wrote:
> On Thu, 2011-05-12 at 19:22 +0900, Masami Hiramatsu wrote:
>> Fix to support kernel stack trace correctly on kprobe-tracer.
>> Since the execution path of kprobe-based dynamic events is different
>> from other tracepoint-based events, normal ftrace_trace_stack() doesn't
>> work correctly. To fix that, this introduces ftrace_trace_stack_regs()
>> which traces stack via pt_regs instead of current stack register.
>
> I'm working to get a "fix" patch set push out, and I included this
> patch. But when I ran it on my arch test (compiling on other archs),
> this patch broke the following:
>
>  arm, blackfin, powerpc, s390.
>
> (Note, due to other bugs, UML and mips does not build to test)
>
> The problem is that these archs do not implement a:
>
>  save_stack_trace_regs() function.

i think only x86 implements that func ?  and its stacktrace.c just
seems to beg for generalization ...
-mike
