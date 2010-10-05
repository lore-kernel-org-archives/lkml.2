Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0JESny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:43:54 -0400
Received: from mx1.spunky.mail.dreamhost.com ([208.97.132.47]:45590 "EHLO
	homiemail-a62.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751822Ab0JESnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:43:53 -0400
Subject: Re: [RFC 0/3] Basic support for LWP
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, robert.richter@amd.com,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20101005145155.GD173@escobedo.osrc.amd.com>
References: <1286212172-654419-1-git-send-email-hans.rosenfeld@amd.com>
	 <alpine.LFD.2.00.1010042358520.2556@localhost6.localdomain6>
	 <20101005145155.GD173@escobedo.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 14:43:40 -0400
Message-ID: <1286304220.2065.0.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-05 at 16:51 +0200, Hans Rosenfeld wrote:
> [ adding Robert ]
> 
> On Mon, Oct 04, 2010 at 06:13:46PM -0400, Thomas Gleixner wrote:
> > > LWP (Light-Weight Profiling) is a new profiling mechanism that allows
> > > user mode processes to gather performance data about themselves with
> > > very low overhead. The specification can be found here:
> > >         http://developer.amd.com/cpu/LWP/Pages/default.aspx
> > 
> > All I can see there is marketing blurb. The spec pdf does not tell me
> > either how the end result of your patches will look like.
> 
> Well, you should get a basic understanding of how LWP works from the
> spec. I'm pretty sure there is more than that blurb in there.
> 
> What I sent _is_ the end result. Supporting LWP in the task switching
> code is the only thing necessary to use the LWP instructions in user
> space. And that is also what I'd like to get some comments on.
> 
> > > This code adds basic support for LWP to the context switch code, which
> > > is the minimum needed to use LWP. Support for other LWP features like
> > > interrupts will be added later.
> > 
> > Oh no. We are not going to merge that and give you a card blanche to
> > come up with another profiling/performance monitoring facility which
> > is completely disconnected to everything else.
> 
> I think you got something wrong here, probably because I wasn't clear
> enough :)
> 
> What I sent was just the basic kernel support, which means
> saving/restoring the LWP state in task switches. Technically no other
> kernel changes are necessary to use LWP in user space programs. No
> kernel framework of any kind is necessary to use LWP. Additionally,
> Robert is checking whether and how LWP support could be integrated
> into perf. This of course depends on having basic LWP task switching
> support in the kernel.

That would be the way to go, I don't think anyone wants yet another
profiling userspace tool.
> 
> > Please provide either the full patch of this facility or at least a
> > reasonable explanation how it will look like when your code is
> > ready. What's the user space interface, how does it hook into perf,
> > etc ...
> 
> The basic principle of LWP is that a user program reserves some memory
> for a LWP control block and a ring buffer, writes the ring buffer
> address and some setup bits into the control block, and executes the
> LLWPCB instruction to load the control block into the CPU. While the
> program runs it can periodically read the samples from the ring buffer
> and do something useful with them. The program being profiled needs to
> include support for LWP to do that. In case you can't or don't want to
> modify the program being profiled, a small LWP library would have to
> be written that would have to be LD_PRELOADed. I don't really know
> what it will look like in the end and how it will be integrated into
> perf. The tool/library developers will probably know best how to make
> use of LWP.
> 
> The point is that LWP is supposed to be controlled and used from user
> space without any kernel interaction, provided that the kernel
> saves/restores the LWP context. That's also how I tested it, using a
> small test program that just uses the LWP instructions.
> 
> Technically LWP is quite similar to the FPU, it even uses the same
> facilities for OS support. Just like FPU support, the kernel doesn't
> have to care at all about what user space is going to do with it. It
> just has to make sure state is saved and restored when necessary.
> 
> 
> Hans
> 
> 


