Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab1K3VwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 16:52:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36366 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab1K3VwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 16:52:04 -0500
Date: Wed, 30 Nov 2011 22:52:00 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, hpa@zytor.com, tglx@linutronix.de,
        mingo@elte.hu, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, robert.richter@amd.com, Andreas.Herrmann3@amd.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] rework of extended state handling, LWP support
Message-ID: <20111130215200.GS24062@one.firstfloor.org>
References: <1322570488-21798-1-git-send-email-hans.rosenfeld@amd.com> <m2ipm2lioy.fsf@firstfloor.org> <20111130173745.GT878@escobedo.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111130173745.GT878@escobedo.osrc.amd.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 06:37:46PM +0100, Hans Rosenfeld wrote:
> On Tue, Nov 29, 2011 at 01:31:09PM -0800, Andi Kleen wrote:
> > Hans Rosenfeld <hans.rosenfeld@amd.com> writes:
> > >
> > > The lazy allocation of the xstate area has been removed. The support for
> > > extended states that cannot be saved/restored lazily, like AMD's LWP,
> > > need this. Since optimized library functions using SSE etc. are widely
> > > used today, most processes would have an xstate area anyway, making the
> > > memory overhead negligible.
> > 
> > Do you have any data on that?  It sounds dubious for specialized
> > workloads.
> 
> What kind of specialized workload do you mean?

Anything that doesn't do large memcpys/memsets: glibc only uses SSE
when you pass large buffers. And then doesn't use the FPU. And possibly
has lots of processes.

Some older glibc did an unconditional FPU initialization at start,
but I believe that's long gone.

-Andi
