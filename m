Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab0EWSlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 14:41:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52744 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab0EWSlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 14:41:09 -0400
Subject: Re: [PATCH 1/2] perf: Add persistent events
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100523183353.GB1408@liondog.tnic>
References: <1274554806-28216-1-git-send-email-bp@alien8.de>
	 <1274554806-28216-2-git-send-email-bp@alien8.de>
	 <1274638513.1674.1727.camel@laptop>  <20100523183353.GB1408@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 May 2010 20:40:47 +0200
Message-ID: <1274640047.1674.1731.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-23 at 20:33 +0200, Borislav Petkov wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Sun, May 23, 2010 at 08:15:13PM +0200
> 
> > On Sat, 2010-05-22 at 21:00 +0200, Borislav Petkov wrote:
> > > Register and enable events marked as persistent right after perf events
> > > has initialized.
> > > 
> > > Not-yet-signed-off-by: Borislav Petkov <bp@alien8.de>
> > 
> > Nah, this is totally wrong.
> > 
> > A persistent event would simply be a regular event, but created by the
> > kernel and not tied to a file-desc's lifetime.
> 
> So you're saying the trace_mce_record() tracepoint for example should
> be created completely internally in the kernel and cease to be a
> tracepoint? Will it still be able to be selected by perf -e?

No, it should be a regular tracepoint as far as tracepoints are
concerned.

But the only thing persistence should add is an instance of a
perf_event, it should not modify either the perf_event nor the
tracepoint code.

