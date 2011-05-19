Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657Ab1ESRUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:20:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40827 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933593Ab1ESRUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:20:51 -0400
Date: Thu, 19 May 2011 19:20:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH] perf: Split up buffer handling from core code
Message-ID: <20110519172039.GA27370@elte.hu>
References: <1305767185-5771-1-git-send-email-fweisbec@gmail.com>
 <20110519073136.GB14049@liondog.tnic>
 <1305793931.2466.7191.camel@twins>
 <20110519141456.GB1956@nowhere>
 <1305816208.2466.7223.camel@twins>
 <20110519145951.GD1956@nowhere>
 <1305818041.2466.7225.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305818041.2466.7225.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2011-05-19 at 16:59 +0200, Frederic Weisbecker wrote:
> > I thought it would be nice to keep it inline for core use, as it's called
> > pretty often from the overflow path.
> 
> That's what I meant.
> 
> > A solution is to have a perf_output_copy_inline() in internal.h
> > and export it through perf_output_copy() in buffer.c 
> 
> If only "external inline" would work :-)
> 
> I'd call it __perf_output_copy() though, less typing.

Just __output_copy() please - if someone is looking at kernel/events/*.c then 
it's pretty clear that it's related to perf.

I.e. non-exposed symbols should lose their perf_ prefixes.

Thanks,

	Ingo
