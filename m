Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab0HBTrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 15:47:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:48375 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab0HBTrY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 15:47:24 -0400
Subject: Re: [RFC] BTS based perf user callchains
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Markus Metzger <markus.t.metzger@intel.com>,
        Robert Richter <robert.richter@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100802184149.GB8962@nowhere>
References: <20100802183506.GA8962@nowhere>
	 <1280774332.1923.245.camel@laptop>  <20100802184149.GB8962@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 02 Aug 2010 21:47:08 +0200
Message-ID: <1280778428.1923.358.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-02 at 20:41 +0200, Frederic Weisbecker wrote:
> On Mon, Aug 02, 2010 at 08:38:52PM +0200, Peter Zijlstra wrote:
> > On Mon, 2010-08-02 at 20:35 +0200, Frederic Weisbecker wrote:
> > > I'm not even sure that will work. Also, while looking at the BTS implementation
> > > in perf, I see we have one BTS buffer per cpu. But that doesn't look right as
> > > the code flow is not linear per cpu but per task. Hence I suspect we need
> > > one BTS buffer per task. But may be someone tried that and encountered a
> > > problem? 
> > 
> > IIRC we flush the buffer when we deschedule the counter.
> 
> 
> Ok. So the buffer is cut on schedule time. It might be nice
> to maintain the buffer progress across scheduling.

We flush it into the perf data buffer.
