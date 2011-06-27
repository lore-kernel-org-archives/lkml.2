Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab1F0NtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 09:49:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab1F0NtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 09:49:09 -0400
Date: Mon, 27 Jun 2011 15:47:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: make former thread ID available via
	PTRACE_GETEVENTMSG after PTRACE_EVENT_EXEC stop (v.2)
Message-ID: <20110627134713.GB3527@redhat.com>
References: <201106262108.43011.vda.linux@googlemail.com> <20110626200442.GA16293@redhat.com> <20110627081139.GY30101@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627081139.GY30101@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27, Tejun Heo wrote:
>
> Hello, Oleg, Denys.
>
> On Sun, Jun 26, 2011 at 10:04:42PM +0200, Oleg Nesterov wrote:
> > May be PT_TRACE_EXEC makes more sense. Note that
> > ptrace_event_enabled() was recently added.
>
> Do we want to enable this silently?  Wouldn't it be better to make it
> dependent on PT_SEIZED?

Hmm. Not sure I understand. Why can't PTRACE_SEIZE add PT_TRACE_EXEC
(and PT_TRACESYSGOOD) along with PT_SEIZED during attach?

I think this makes more sense, this way the tracer can disable this
later via PTRACE_SETOPTIONS if it wants. Not that I think this is really
useful but still. Otherwise we are going to silently disable
PTRACE_O_TRACEEXEC, this may be confusing.


But. If we want the PT_TRACE_EXEC behaviour for PT_SEIZED task (personally
I think we do), then we should probably record the old pid unconditionally,
the tracer can attach later.

Even in this case ptrace_event(PTRACE_EVENT_EXEC) can race with detach +
attach in theory, but I think in this case we do not care.

Oleg.

