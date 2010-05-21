Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0EULSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 07:18:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37278 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab0EULSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 07:18:09 -0400
Subject: Re: [PATCH 09/10] perf: Remove more fastpath code
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1274440538.26328.3575.camel@gandalf.stny.rr.com>
References: <20100521090201.326791353@chello.nl>
	 <20100521090710.852926930@chello.nl>
	 <1274440538.26328.3575.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 13:18:06 +0200
Message-ID: <1274440686.1674.1705.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 07:15 -0400, Steven Rostedt wrote:
> > -     if (WARN_ON_ONCE(((long)(handle->head - handle->offset)) < 0))
> > -             return;
> 
> Are you sure you want to remove this? I mean, sanity checks are a small
> cost (I have several in the ftrace ring buffer) and can catch bugs in
> case something happens during development. Especially when the code is
> under a lot of flux.

Yeah, I pondered adding a CONFIG_PERF_DEBUG for that.. thing is I was
tracking 2 variables just for this, and that seemed a bit excessive.

> I even have a sanity check that Ingo asked me to add, which would detect
> if a tracer (not the ring buffer, but the user of the ring buffer)
> recursed on itself. I think that check detected one bug in the function
> tracer in the begging, but hasn't caught anything since.

I still have recursion checks.

