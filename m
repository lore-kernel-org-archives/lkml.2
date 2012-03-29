Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2C2IL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 04:11:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:48366 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab2C2ILu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 04:11:50 -0400
Message-ID: <1333008684.3010.9.camel@pasglop>
Subject: Re: [GIT PULL] Disintegrate and kill asm/system.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-arch@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>, arnd@arndb.de,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        paul.gortmaker@windriver.com, hpa@zytor.com, akpm@linux-foundation.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Date: Thu, 29 Mar 2012 19:11:24 +1100
In-Reply-To: <CA+55aFzjQ7qb=bPAj_gGoGLPXOGweTaqtmOBZH4mUt8E_KQwsg@mail.gmail.com>
References: <5599.1332958811@redhat.com> <30702.1332989444@neuling.org>
	 <20120329135555.06593144b65bf81cc9191f8a@canb.auug.org.au>
	 <20120329151544.ef2117821dfb459e8b52af48@canb.auug.org.au>
	 <CA+55aFzn=bsH76hPDUgS-FBP=RVu51gwmRdqjkw5RJO=Q_cRfA@mail.gmail.com>
	 <20120329154238.1ce219f7c998da45452af4b2@canb.auug.org.au>
	 <CA+55aFzjQ7qb=bPAj_gGoGLPXOGweTaqtmOBZH4mUt8E_KQwsg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 22:02 -0700, Linus Torvalds wrote:
> On Wed, Mar 28, 2012 at 9:42 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > How about this (build tested on powerpc allyesconfig):
> 
> Looks better.
> 
> Grant - what's the plan about that CONFIG_VIRQ_DEBUG thing? In theory
> something like it could be useful as a generic thing, but at least
> right now it is clearly powerpc-specific (not just that the config
> option only exists for powerpc: it has that whole
> 'powerpc_debugfs_root' thing in it)?
> 
> Stephen's patch very much looks like the right thing, but if there was
> some plan to actually make this generic ...

Yes, as I said earlier I think Grant should make it generic, there's
no reason to keep that powerpc specific, it's fairly useful and nothing
in userspace relies on the existing location of the debugfs file that I
know about.

Another option is to put the mapping information in /proc/interrupts but
worry that changing anything in there (like adding a column) will break
countless userspace tools.

Cheers,
Ben.
 

