Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161Ab0JZReP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:34:15 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:34709 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab0JZReN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:34:13 -0400
Date: Tue, 26 Oct 2010 18:34:10 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Beulich <JBeulich@novell.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        David Howells <dhowells@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Partially revert patch that encloses asm-offset.h numbers
 in brackets
In-Reply-To: <4CC702EB.1000301@zytor.com>
Message-ID: <alpine.LFD.2.00.1010261759410.15889@eddie.linux-mips.org>
References: <4CC5B1A1020000780001EF7C@vpn.id2.novell.com> <20101025140218.5092.74117.stgit@warthog.procyon.org.uk> <28707.1288018465@redhat.com> <4CC5B8D3020000780001EFB4@vpn.id2.novell.com> <AANLkTi=mpKRQgZp5zCoCsBtkuWHrpkOq2Zch-OOGu4CC@mail.gmail.com>
 <4CC5A748.6050903@zytor.com> <AANLkTik1HB-P0x0e8ucHz7323F-_qAzkaHrHy1Yq4qwo@mail.gmail.com> <4CC5B246.5070909@zytor.com> <alpine.LFD.2.00.1010261126590.15889@eddie.linux-mips.org> <4CC702EB.1000301@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, H. Peter Anvin wrote:

> >  Also note that *.*.9x versions are snapshots from the FSF repository (so 
> > there's no fixed date associated with them), which also delegates 
> > maintenance responsibility to whoever packages them and makes available to 
> > people.  In the state as imported from the repository they may have odd 
> > problems or grave bugs, as exhaustive regression testing is generally only 
> > made after a release branch has been created and otherwise changes to the 
> > head of the tree are only tested for a limited subset of targets before 
> > they are applied.  Therefore local fixes are inevitable for them anyway.
> 
> Well, sort of... the x.x.9x releases used in production -- specifically
> the ones with a numbering scheme like x.x.9x.0.x -- in the Linux world
> tend to be the ones maintained and released by H.J. Lu:
> 
> http://www.kernel.org/pub/linux/devel/binutils/

 Yeah, in practice this means the packagers have an additional choice to 
pester H.J. if something goes wrong. ;)

 I used H.J.'s releases once too, then around 2.9.4 I switched over to 
pristine FSF sources as I figured out I needed to make own fixes for the 
MIPS port and it was easier for me to propagate them upstream this way.  
And overall I found no problems (apart from the usual bugs here and there 
every once in a while) having since used them for the Alpha, MIPS, VAX and 
x86 ports of Linux (OK, perhaps x86 is not a port ;) ), so the choice 
between the two flavours is mostly the matter of taste it would seem.

> >  And last but not least binutils are one of the easier tools to build from 
> > sources, so installing a newer version, especially when it comes to native 
> > tools (hardly anyone uses cross-compilation targeting x86, I believe), 
> > somewhere under $HOME to use for kernel builds is a trivial effort:
> > 
> > $ ./configure --prefix=$HOME/somewhere && make && make install
> > $ PATH=$HOME/somewhere/bin:$PATH
> > 
> > Certainly much easier than building the kernel, especially when it comes 
> > to selecting the right configuration options.
> 
> Yes, although there is also a version dependency between binutils and
> gcc, as I unhappily found out trying to run an upversion gcc on an old
> distro at one point.

 Fair enough if you do it this way, but switching to a higher version of 
binutils shouldn't ever be a problem.  GCC detects some binutils features 
at the configuration time and sets itself up accordingly, but these do not 
get removed, at least not that I heard of.

  Maciej
