Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750976Ab0DFN6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 09:58:00 -0400
Received: from mail2.shareable.org ([80.68.89.115]:60003 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab0DFN5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 09:57:53 -0400
Date: Tue, 6 Apr 2010 14:57:32 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Scott Lurndal <scott.lurndal@3leafsystems.com>,
       David Howells <dhowells@redhat.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] X86: Optimise fls(), ffs() and fls64()
Message-ID: <20100406135732.GC24003@shareable.org>
References: <20100326144241.8583.95617.stgit@warthog.procyon.org.uk> <alpine.LFD.2.00.1003261005490.3721@i5.linux-foundation.org> <20100326173730.GA27489@pendragon.3leafnetworks.com> <alpine.LFD.2.00.1003261038160.3721@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003261038160.3721@i5.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Fri, 26 Mar 2010, Scott Lurndal wrote:
> > 
> > I wonder if Intel's EM64 stuff makes this more deterministic, perhaps
> > David's implementation would work for x86_64 only?
> 
> Limiting it to x86-64 would certainly remove all the worries about all the 
> historical x86 clones.
> 
> I'd still worry about it for future Intel chips, though. I absolutely 
> _detest_ relying on undocumented features - it pretty much always ends up 
> biting you eventually. And conditional writeback is actually pretty nasty 
> from a microarchitectural standpoint.

On the same subject of relying on undocumented features:

  /* If SMP and !X86_PPRO_FENCE. */
  #define smp_rmb()      barrier()

I've seen documentation, links posted to lkml ages ago, which implies
this is fine on 64-bit for both Intel and AMD.

But it appears to be relying on undocumented behaviour on 32-bit...

Are you sure it is ok?  Has anyone from Intel/AMD ever confirmed it is
ok?  Has it been tested?  Clones?

-- Jamie
