Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab1BQMq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 07:46:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:60121 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab1BQMq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 07:46:26 -0500
Subject: Re: [kbuild] Re: linux-next: build failure after merge of the tip
 tree
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>, Michal Marek <mmarek@suse.cz>
In-Reply-To: <20110217124304.GA27504@elte.hu>
References: <20110131154259.dca1f7e6.sfr@canb.auug.org.au>
	 <20110217144743.2db26b27.sfr@canb.auug.org.au>
	 <20110217124304.GA27504@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 17 Feb 2011 13:45:47 +0100
Message-ID: <1297946747.2413.1717.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 13:43 +0100, Ingo Molnar wrote:
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi all,
> > 
> > On Mon, 31 Jan 2011 15:42:59 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> > > failed like this:
> > > 
> > > x86_64-linux-gcc: arch/x86/lib/memmove_64.c: No such file or directory
> > > 
> > > Caused by commit 9599ec0471deae24044241e2173090d2cbc0e899 ("x86-64, mem:
> > > Convert memmove() to assembly file and fix return value bug") interacting
> > > with our build system.
> > > 
> > > After removing arch/x86/lib/.memmove_64.o.cmd (left over from the build
> > > before merging the tip tree) from my object tree, it built correctly.
> > 
> > I am still getting this (of course).
> 
> You reported this as a -tip build failure - but it appears to be some sort of kbuild 
> bug/artifact, right? There was a leftover .memmove_64.o.cmd file from an old tree.
> 
> When jumping between kernel versions via git checkout a 'make mrproper' is generally 
> needed. In most cases 'make' will figure things out but it's not always guaranteed.
> 
> So for example there are version transitions where a stale include/asm links could 
> cause build problems.

Yeah, I run into this problem once every few days, totally annoying. A
make clean does fix it so I couldn't be arsed to actually submit myself
to Kbuild voodoo, but if someone who knows about that stuff could come
up with a fix I'd be most obliged.


