Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab0ESJNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:13:36 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:57525 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab0ESJNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:13:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C/0xbWaNiOG8bsq/RNqy1XxIvnXA1Cq1SY2XZ7Hzi2H93GRGW/QGVYouL4EuzBBoaQ
         Pt+YvSWgrzbT107pksPaXzWeNBf4nzbpr2xPFivhiqK3xrOgtVTR9Vivz4CkHKRytpqU
         1fTLAa3uBTALzqPZFJb5TQ/+JArMxgRclg8fA=
Date: Wed, 19 May 2010 11:13:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/ftrace: Optimize perf/tracepoint
	interaction for single events
Message-ID: <20100519091333.GL5704@nowhere>
References: <tip-4f41c013f553957765902fb01475972f0af3e8e7@git.kernel.org> <20100519075804.GF5704@nowhere> <1274257123.5605.10260.camel@twins> <20100519082335.GG5704@nowhere> <1274259525.5605.10352.camel@twins> <20100519090654.GK5704@nowhere> <1274260348.5605.10379.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274260348.5605.10379.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 11:12:28AM +0200, Peter Zijlstra wrote:
> On Wed, 2010-05-19 at 11:06 +0200, Frederic Weisbecker wrote:
> > On Wed, May 19, 2010 at 10:58:45AM +0200, Peter Zijlstra wrote:
> > > How about something like the below?
> > > 
> > > 
> > > ---
> > > Subject: perf, trace: Remove IRQ-disable from perf/tracepoint interaction
> > > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Date: Wed May 19 10:52:27 CEST 2010
> > > 
> > > 
> > > 
> > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > ---
> > 
> > 
> > 
> > Looks fine if we don't have nested irqs.
> 
> Well, I was thinking the per-context recursion thing would sort that
> out. We can have 1 event per context in-flight.


Ah good point.

