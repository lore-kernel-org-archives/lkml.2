Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab0HYBnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 21:43:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:49005 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab0HYBnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 21:43:02 -0400
Subject: Re: [PATCH 0/3] Generalise ARM perf-events backend for oprofile
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20100823105759.GA18638@infradead.org>
References: <1282560381-7700-1-git-send-email-matt@console-pimps.org>
	 <20100823105759.GA18638@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 11:41:56 +1000
Message-ID: <1282700516.22370.567.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-23 at 06:57 -0400, Christoph Hellwig wrote:
> On Mon, Aug 23, 2010 at 11:46:18AM +0100, Matt Fleming wrote:
> > The perf-events backend for OProfile that Will Deacon wrote in
> > 8c1fc96f6fd1f361428ba805103af0d0eee65179 ("ARM: 6072/1: oprofile: use
> > perf-events framework as backend") is of use to more architectures
> > than just ARM. Move the code into drivers/oprofile/ so that SH can use
> > it instead of the nearly identical copy of its OProfile code.
> 
> Nice, I didn't know such a backend already existed.  Now that you
> have made it generic we should aim towards making it the only oprofile
> backend and getting rid of all the duplication.

Even better would be to do the surgery at a higher level and provide the
oprofile API without the oprofile buffer management. My experience is
that it doesn't scale, and on heavily threaded large SMP setup, there is
an enormous amount of time wasted contending on the global oprofile
buffer mutex.

Cheers,
Ben.


