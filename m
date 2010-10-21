Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab0JUHWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 03:22:32 -0400
Received: from fep16.mx.upcmail.net ([62.179.121.36]:54946 "EHLO
	fep16.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab0JUHWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 03:22:31 -0400
X-SourceIP: 80.56.199.130
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        2nddept-manager@sdl.hitachi.co.jp
In-Reply-To: <4CBFAC70.30602@hitachi.com>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com>
	 <20101019184111.GA17266@elte.hu> <20101020154045.GA18353@elte.hu>
	 <20101020164324.GC7348@redhat.com>  <4CBFAC70.30602@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 09:22:24 +0200
Message-ID: <1287645744.3488.57.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=zlRBWuFCZaNL9+WHNm1pWLowY5Lx061w2zJBJiDkNAU= c=1 sm=0 a=LuwKl7ggZIAA:10 a=IkcTkHD0fZMA:10 a=WiKPNwC-F9ckYRo5hk4A:9 a=Yt9w8u2Eb0f2lNcPh8BuB6BrmxkA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 11:58 +0900, Masami Hiramatsu wrote:

> It seems there can be a bug in stop_machine() routine under
> heavy use. usually that is called just once at a time, but jump
> label and optprobe might call it heavily (thousands times?).
> So some racy situation can be happen easily.

There are people doing hotplug stress testing, that too results in heavy
stop_machine usage.

