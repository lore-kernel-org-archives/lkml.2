Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0EWSyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 14:54:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36835 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119Ab0EWSyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 14:54:15 -0400
Date: Sun, 23 May 2010 20:54:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: Add persistent events
Message-ID: <20100523185411.GA5608@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org
References: <1274554806-28216-1-git-send-email-bp@alien8.de>
 <1274554806-28216-2-git-send-email-bp@alien8.de>
 <1274638513.1674.1727.camel@laptop>
 <20100523183353.GB1408@liondog.tnic>
 <1274640047.1674.1731.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1274640047.1674.1731.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Sun, May 23, 2010 at 08:40:47PM +0200

> > > A persistent event would simply be a regular event, but created by the
> > > kernel and not tied to a file-desc's lifetime.
> > 
> > So you're saying the trace_mce_record() tracepoint for example should
> > be created completely internally in the kernel and cease to be a
> > tracepoint? Will it still be able to be selected by perf -e?
> 
> No, it should be a regular tracepoint as far as tracepoints are
> concerned.
> 
> But the only thing persistence should add is an instance of a
> perf_event, it should not modify either the perf_event nor the
> tracepoint code.

which means that subsystems which initialize earlier than perf (mce,
for example) should have to be notified when perf is ready so that they
could register a persistent event. How does that sound?

-- 
Regards/Gruss,
    Boris.
