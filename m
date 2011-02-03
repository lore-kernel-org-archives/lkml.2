Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab1BCJhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 04:37:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52054 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab1BCJhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 04:37:06 -0500
Subject: Re: [PATCH 5/5] perf, x86: Add support for AMD family 15h core
 counters
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110203090001.GG5874@erda.amd.com>
References: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
	 <1296664860-10886-6-git-send-email-robert.richter@amd.com>
	 <1296666198.26581.343.camel@laptop> <20110202172419.GB5874@erda.amd.com>
	 <1296667777.26581.349.camel@laptop>
	 <AANLkTikdLUkv3y6-g=OegtJD5bXS0vPPjLMR1jmQjCZz@mail.gmail.com>
	 <20110203090001.GG5874@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 10:38:03 +0100
Message-ID: <1296725883.26581.359.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 10:00 +0100, Robert Richter wrote:
> 
> 
> ok, nb events may be implemented independent from core events in a
> separate struct pmu.
> 
> I still would prefer a lookup table for counter addresses. Adding a
> shift parameter to struct x86_pmu to do a
> 
>       addr = base + (index << shift)
> 
> seems to me a quite special solution that may not be reused in other
> implementations

What other implementations? I hope people will not re-arrange the MSR
layout on every new model, that'd be quite annoying.

>  while a lookup table is more generic. I also don't
> see a performance or memory impact there.

Well it is an extra pointer chase and data cache hit just to get
something you can trivially compute.

> Anyway, a shift parameter would work too. What do you think? 

I think the alternatives thing is probably nicest, except for having to
write the bits in asm.

