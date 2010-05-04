Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab0EDJQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 05:16:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:37231 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab0EDJQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 05:16:49 -0400
Subject: Re: [PATCH] perf: implement recording/reporting per-cpu samples
From: Peter Zijlstra <peterz@infradead.org>
To: Arun Sharma <aruns@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com
In-Reply-To: <w2u850c51c31005031353x9be8ca7h90c244d64675ce3e@mail.gmail.com>
References: <20100503203813.GA17886@sharma-home.net>
	 <1272919356.1642.154.camel@laptop>
	 <w2u850c51c31005031353x9be8ca7h90c244d64675ce3e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 May 2010 11:16:38 +0200
Message-ID: <1272964598.5605.133.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-03 at 13:53 -0700, Arun Sharma wrote:
> On Mon, May 3, 2010 at 1:42 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Mon, 2010-05-03 at 13:38 -0700, Arun Sharma wrote:
> > > Enable PERF_SAMPLE_CPU by default. Implement --sort cpu.
> >
> > Why? The downside is that you unconditionally grow each sample and thus
> > increase the overhead for something that doesn't make sense for the
> > normal (task-inherit) case.
> 
> In a shared multi-core environment, users want to analyze why their
> program was slow. In particular, if the code ran slower only on
> certain CPUs due to interference from other programs or kernel
> threads, they want to know that.

But for that you use perf record -a, right? So you record all cpus
allways -- otherwise there is no telling what was happening to make it
go slow.

> But that's just our use case. The patch is mostly about --sort cpu
> option. If you want to drop the part that enables PERF_SAMPLE_CPU by
> default, that's fine by me.

Right, it would be very nice if we can avoid growing the default sample
size. Also, your changelog needs work, please explain the full usecase
that goes with this feature.

Explain the thing you're wanting to measure, explain the implementation
and maybe give a short example.

