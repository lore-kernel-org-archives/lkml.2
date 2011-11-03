Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1KCOCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:02:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63327 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1KCOCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:02:13 -0400
X-Authority-Analysis: v=1.1 cv=PzmnriOiyqYdyw8suerSEFMr8oy2Ua58JL+Rk7iuDKE= c=1 sm=0 a=CMzmyBkqurIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VwQbUJbxAAAA:8 a=zeyiR1NSKY-_5dBrGPcA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320328931.27370.11.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] event: fix TP_printk() argument in sched_switch
From: Steven Rostedt <rostedt@goodmis.org>
To: avagin@gmail.com
Cc: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Thu, 03 Nov 2011 10:02:11 -0400
In-Reply-To: <4EB28FA6.3040204@gmail.com>
References: <1320273611-2463347-1-git-send-email-avagin@openvz.org>
	 <1320275277.4793.54.camel@gandalf.stny.rr.com> <4EB28FA6.3040204@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 16:57 +0400, Andrew Vagin wrote:
> > NACK!
> >
> > This is a perf userspace bug, not a kernel one. Please fix the userspace
> > tool instead.
> >
> > Note, the new version of libparsevent handles this case without issue.
> > Perf just needs to be updated.
> I don't understand. I've got 
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
> and it reports the same error. Where am I wrong?
> 
> # ./trace-cmd report 2> log
> 
> <idle>-0     [001] 1516333.292126: sched_switch:         [FAILED TO 
> PARSE] prev_comm=kworker/0:0 prev_pid=0 prev_prio=120 prev_state=0x0 
> next_comm=trace-cmd next_pid=2900 next_prio=120

Ah, I tested on a kernel without the updated format field.

But I still stand that the tool is broken and not the kernel.

I'll update both trace-cmd and perf to handle this breakage. Sad that I
still need to update two locations :(

-- Steve


> 
> # cat log
> trace-cmd: No such file or directory
>    Error: expected type 5 but read 4
>    Error: expected type 4 but read 0
>    failed to read event print fmt for sched_switch
> trace-cmd: Received SIGINT


