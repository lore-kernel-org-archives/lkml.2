Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719Ab0JZKxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:53:53 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:42262 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab0JZKxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:53:50 -0400
Date: Tue, 26 Oct 2010 11:53:47 +0100 (BST)
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
In-Reply-To: <4CC5B246.5070909@zytor.com>
Message-ID: <alpine.LFD.2.00.1010261126590.15889@eddie.linux-mips.org>
References: <4CC5B1A1020000780001EF7C@vpn.id2.novell.com> <20101025140218.5092.74117.stgit@warthog.procyon.org.uk> <28707.1288018465@redhat.com> <4CC5B8D3020000780001EFB4@vpn.id2.novell.com> <AANLkTi=mpKRQgZp5zCoCsBtkuWHrpkOq2Zch-OOGu4CC@mail.gmail.com>
 <4CC5A748.6050903@zytor.com> <AANLkTik1HB-P0x0e8ucHz7323F-_qAzkaHrHy1Yq4qwo@mail.gmail.com> <4CC5B246.5070909@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010, H. Peter Anvin wrote:

> > No reason to make for maintenance problems and uglier code if we can
> > just say "get a newer gas" to a few people. It's not like we haven't
> > done that with gcc and other tools too.
> 
> The problem is that 2.16 isn't all that old; al lot of the "enterprise"
> distros still ship it or AFAIK even older versions.  2.6.90 which I
> *think* is the first fixed version dates from April 2005, so is
> currently 5 years old; maybe that is within reason to kill off.

 For the record -- binutils 2.21 are about to be released and for several 
years now the schedule has roughly been one major release per year, 
sometimes followed by some bug-fix minor releases as needed.  That'll make 
2.16 *five* releases away from the current version and hardly a reason to 
keep maintaining support for it in the face of critical problems.

 If some random distribution insists on maintaining such old tools, then 
it's their responsibility to backport critical fixes, such as these 
required to get the parser (or whatever piece of code is responsible for 
the breakage observed here) right, isn't it?  Then once they did it, they 
can patch up their kernels to accept their tools too.

 Also note that *.*.9x versions are snapshots from the FSF repository (so 
there's no fixed date associated with them), which also delegates 
maintenance responsibility to whoever packages them and makes available to 
people.  In the state as imported from the repository they may have odd 
problems or grave bugs, as exhaustive regression testing is generally only 
made after a release branch has been created and otherwise changes to the 
head of the tree are only tested for a limited subset of targets before 
they are applied.  Therefore local fixes are inevitable for them anyway.

 And last but not least binutils are one of the easier tools to build from 
sources, so installing a newer version, especially when it comes to native 
tools (hardly anyone uses cross-compilation targeting x86, I believe), 
somewhere under $HOME to use for kernel builds is a trivial effort:

$ ./configure --prefix=$HOME/somewhere && make && make install
$ PATH=$HOME/somewhere/bin:$PATH

Certainly much easier than building the kernel, especially when it comes 
to selecting the right configuration options.

  Maciej
