Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab0E1PSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:18:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52030 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab0E1PR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:17:59 -0400
Subject: Re: [PATCH 1/2] perf: Add persistent events
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@alien8.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100528143311.GB9710@elte.hu>
References: <1274554806-28216-1-git-send-email-bp@alien8.de>
	 <1274554806-28216-2-git-send-email-bp@alien8.de>
	 <1274638513.1674.1727.camel@laptop> <20100523183353.GB1408@liondog.tnic>
	 <1274640047.1674.1731.camel@laptop> <20100523185411.GA5608@liondog.tnic>
	 <1274642601.1674.1755.camel@laptop> <20100525073246.GA6085@liondog.tnic>
	 <1274799588.5882.1572.camel@twins>  <20100528143311.GB9710@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 28 May 2010 17:17:40 +0200
Message-ID: <1275059860.27810.9635.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 16:33 +0200, Ingo Molnar wrote:

> >  2) get these things a buffer, perf_events as created don't actually
> >     have an output buffer, normally that is created at mmap() time, but
> >     since you cannot mmap() a kernel side event, it doesn't get to have
> >     a buffer. This could be done by extracting perf_mmap_data_alloc()
> >     into a sensible interface.
> 
> #2 could be a new syscall: sys_create_ring_buffer or so?

No, they need a buffer in-kernel, syscalls aren't the ideal tool for
that :-)

I've got patches refactoring the whole buffer stuff to make it more a
self-contained entity.
