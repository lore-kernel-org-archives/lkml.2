Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab0C2ONu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:13:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:52377 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab0C2ONt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:13:49 -0400
Subject: Re: [RFC,PATCH 2/2] perf, x86: Utilize the LBRs for machine/oops 
 debugging
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@elte.hu, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <bd4cb8901003290547u1baa58fer762da04790a195ab@mail.gmail.com>
References: <20100329122021.765109681@chello.nl>
	 <20100329122138.848413757@chello.nl>
	 <bd4cb8901003290547u1baa58fer762da04790a195ab@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 16:13:44 +0200
Message-ID: <1269872024.12097.337.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 13:47 +0100, Stephane Eranian wrote:
> On Mon, Mar 29, 2010 at 1:20 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > The LBRs are relatively cheap to keep enabled and provide some history
> > to OOPSen, also some CPUs are reported to keep them over soft-reset,
> > which allows us to use them to debug things like tripple faults.
> >
> > Therefore introduce a boot option: lbr_debug=on, which always enable
> > the LBRs and will print the LBRs on CPU init and die().
> >
> 
> When this is enabled, it will prevent changing the LBR configuration to
> record only selected branches. Unless you are willing to accept filtered
> content in the kernel dump. 

Sure, but since we don't support that silly config reg anyway that's
pretty much not an issue ;-)

