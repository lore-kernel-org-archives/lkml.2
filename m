Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552Ab0FKVZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:25:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47438 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab0FKVZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:25:41 -0400
Subject: Re: perf_disable()
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100611210405.GC5234@nowhere>
References: <1276273784.2077.2055.camel@twins>
	 <20100611210405.GC5234@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 11 Jun 2010 23:25:28 +0200
Message-ID: <1276291528.1745.155.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 23:04 +0200, Frederic Weisbecker wrote:
> On Fri, Jun 11, 2010 at 06:29:44PM +0200, Peter Zijlstra wrote:
> > There is a fun little recursion issue with perf_adjust_period(), where
> > if we fully removed perf_disable() we could end up calling pmu::stop()
> > twice and such.
> 
> 
> 
> We can have a local_t made nesting level on the stop/start that could easily
> deal with this.

Fanning it out to the relevant pmu implementation is the interesting
part..


