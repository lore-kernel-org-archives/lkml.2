Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488Ab2EUSYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:24:07 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:59830 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933438Ab2EUSYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:24:02 -0400
Date: Mon, 21 May 2012 20:24:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
Message-ID: <20120521182400.GA6043@merkur.ravnborg.org>
References: <20120521.050300.1434374935904126254.davem@davemloft.net> <CA+55aFzag=LfduvHSmE34nEVYOk=MRhUMzK854+icLwthmz5Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzag=LfduvHSmE34nEVYOk=MRhUMzK854+icLwthmz5Ng@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 10:37:23AM -0700, Linus Torvalds wrote:
> On Mon, May 21, 2012 at 2:03 AM, David Miller <davem@davemloft.net> wrote:
> >
> > There is going to be a merge conflict between the commit in the
> > net-next tree that adds the Sparc BPF JIT, and the one in here which
> > adds arch/sparc/Kbuild.  It should be quite easy to resolve.
> 
> Ok, so that had a very obvious resolution, and a "cleaner, but scarier" version.
> 
> I picked the cleaner but scarier one - the one that should make the
> BFP JIT be built when you do "make arch/sparc" by putting the net
> thing into the new arch/sparc/Kbuild file.
OK.

> 
> I did minimal testing with "make ARCH=sparc" without actually
> *building* anything, and in the process also fixed the fact that you
> should not select HAVE_BPF_JIT unless networking is enabled (crappy
> interface - maybe that "if NET" part really should be in the
> HAVE_BPF_JIT rules, not in all the architectures?)

HAVE_BPF_JIT is only used to make the BPF_JIT prompt visible.
And BPF_JIT depends on NET.

So the "if NET" part in the select is redundant but not strictly wrong.

	Sam
