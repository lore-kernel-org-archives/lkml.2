Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab2JWNvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:51:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:42894 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978Ab2JWNvh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:51:37 -0400
Message-ID: <1351000250.13456.34.camel@twins>
Subject: Re: [PATCH 05/34] perf, x86: Report PEBS event in a raw format
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Date: Tue, 23 Oct 2012 15:50:50 +0200
In-Reply-To: <20121023133000.GX16230@one.firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
	 <1350602382-12771-6-git-send-email-andi@firstfloor.org>
	 <1350995474.13456.12.camel@twins>
	 <20121023133000.GX16230@one.firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 15:30 +0200, Andi Kleen wrote:
> > Also, there's an alignment issue there, the raw.data is 32bit offset,
> > the record is u64 aligned, leaving the output stream offset, wrecking
> > things.
> 
> Can you explain more? Not sure I understand.

PERF_SAMPLE_RAW has a u32 size header and starts the data after that.
This means you PERF_SAMPLE_RAW output ends up on a u32 aligned end
address -- assuming the data is a u64 multiple, this is not good.

> It appears to work at least.

It would on x86, I'm fairly sure it'll break on things like SPARC. We
used to have checks in the userspace code to warn for this on x86 as
well. Not sure if that's still there.

Hmm, so in kernel/events/core.c:perf_prepare_sample() there's a
WARN_ON_ONCE() in the PERF_SAMPLE_RAW branch that should trigger with
this.

> > 
> > And as with any ABI extension, it should come with useful userspace to
> > make use of it.
> 
> There are already scripts available to use it, see Feng's patchkit.

That's a whole other patchkit, meaning this doesn't belong here.

I never can seem to figure out how to use the scripts mess :/ acme, is
there anything we could do to make that stuff usable? There's a ton of
crap under scripts/ but I don't even know how to get that stuff to run.

What's more, all that nonsense is in weird languages I don't do either,
making it less useful than usual.

In short, I don't consider script/ to be proper userspace since its
bloody useless.
