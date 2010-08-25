Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab0HYJIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:08:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47741 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145Ab0HYJI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:08:27 -0400
Subject: Re: [PATCH 0/3] Generalise ARM perf-events backend for oprofile
From: Will Deacon <will.deacon@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1282700516.22370.567.camel@pasglop>
References: <1282560381-7700-1-git-send-email-matt@console-pimps.org>
	 <20100823105759.GA18638@infradead.org> <1282700516.22370.567.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 10:07:22 +0100
Message-ID: <1282727242.5727.7.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Aug 2010 09:07:26.0732 (UTC) FILETIME=[F0188CC0:01CB4434]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben,

On Wed, 2010-08-25 at 02:41 +0100, Benjamin Herrenschmidt wrote:
> On Mon, 2010-08-23 at 06:57 -0400, Christoph Hellwig wrote:
> > On Mon, Aug 23, 2010 at 11:46:18AM +0100, Matt Fleming wrote:
> > > The perf-events backend for OProfile that Will Deacon wrote in
> > > 8c1fc96f6fd1f361428ba805103af0d0eee65179 ("ARM: 6072/1: oprofile: use
> > > perf-events framework as backend") is of use to more architectures
> > > than just ARM. Move the code into drivers/oprofile/ so that SH can use
> > > it instead of the nearly identical copy of its OProfile code.
> >
> > Nice, I didn't know such a backend already existed.  Now that you
> > have made it generic we should aim towards making it the only oprofile
> > backend and getting rid of all the duplication.
> 
> Even better would be to do the surgery at a higher level and provide the
> oprofile API without the oprofile buffer management. My experience is
> that it doesn't scale, and on heavily threaded large SMP setup, there is
> an enormous amount of time wasted contending on the global oprofile
> buffer mutex.
> 
Ideally, the OProfile userspace tools would talk native perf and we
could do away with oprofilefs and the oprofile buffer altogether.
Compatibility with the old [read current] OProfile tools can be
maintained using these patches until the API is deprecated.

Or is that a bit too optimistic? :)

Will


