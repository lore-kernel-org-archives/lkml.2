Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab0LIVuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:50:35 -0500
Received: from mail.openrapids.net ([64.15.138.104]:55845 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756915Ab0LIVue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:50:34 -0500
Date: Thu, 9 Dec 2010 16:50:31 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
        William Cohen <wcohen@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jason Baron <jbaron@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zhaolei <zhaolei@cn.fujitsu.com>,
        Anton Blanchard <anton@samba.org>
Subject: Re: [RFC PATCH] ftrace trace event: introduce assignment macros
Message-ID: <20101209215031.GA9296@Krystal>
References: <20101209162210.GB6769@Krystal> <20101209170027.GF1712@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209170027.GF1712@nowhere>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:42:39 up 16 days,  2:45,  4 users,  load average: 0.04, 0.05,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Thu, Dec 09, 2010 at 11:22:11AM -0500, Mathieu Desnoyers wrote:
> > This patch proposes encapsulation of the raw assignments within TP_fast_assign()
> > by introducing tp_assign() and tp_memcpy() macros. This will allow us to:
> > 
> > - generically filter from input fields,
> > - redefine the field write primitives.
> > 
> > The current macros map directly to the old code. I changed the documentation in
> > tracepoint.txt to reflect these new primitives, but all TRACE_EVENT() users
> > should gradually update their code to use these macro wrappers rather than raw
> > "=" assignments or mempcy() calls.

Hrm, while we are there, I notice the presence of __assign_str(). Maybe we
should also create the following mapping, for the sake of streamlining the
interface:

#define tp_strcpy(dest, src)   __assign_str(dest, src)

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
