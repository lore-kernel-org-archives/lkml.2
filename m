Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0FAGR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 02:17:58 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:53729 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab0FAGR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 02:17:56 -0400
Date: Tue, 1 Jun 2010 08:17:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Alexander Viro <viro@ftp.linux.org.uk>
Cc: tytso@mit.edu, Alex Buell <alex.buell@munted.org.uk>,
       Mailing Lists - Kernel Developers 
	<linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Article in Phoronix about loss of performance in 2.6.35 release
 candidates
Message-ID: <20100601061749.GA26705@elte.hu>
References: <1275347969.29006.5.camel@lithium.local.net>
 <20100601041028.GB4426@thunk.org>
 <AANLkTikRoff0zK-o8W4Wb_MveGibxlOG8mnrQMBtYZOY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikRoff0zK-o8W4Wb_MveGibxlOG8mnrQMBtYZOY@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Tue, Jun 1, 2010 at 7:10 AM,  <tytso@mit.edu> wrote:
> > On Tue, Jun 01, 2010 at 12:19:29AM +0100, Alex Buell wrote:
> >> http://www.phoronix.com/vr.php?view=14976
> >>
> >> Question: Why?
> >
> > One of the theories that has been advanced is that it's simply this
> > problem:
> >
> > ? ? ? ?http://lkml.org/lkml/2010/5/22/154
> >
> > If so, it points out how idiotic Phoronix is about not being able to
> > notice udev pegging the CPU at 100% being someone bad for its
> > benchmark runs. ?:-)
> >
> > OTOH, this bug has been known for over a week, and it is sort sad that
> > we haven't reverted this patch. ?It looks like the conversation has
> > died, but without a fix?
> 
> It's fixed by 1eb2cbb6d5efe129 so the problem doesn't exist for 2.6.35-r1.

Btw., the changelog in 1eb2cbb6d5efe129:

 | From 1eb2cbb6d5efe129cd006691267ce513c0aa59da Mon Sep 17 00:00:00 2001
 | From: Al Viro <viro@zeniv.linux.org.uk>
 | Date: Thu, 27 May 2010 11:11:06 -0400
 | Subject: [PATCH] Revert "anon_inode: set S_IFREG on the anon_inode"
 | 
 | This reverts commit a7cf4145bb86aaf85d4d4d29a69b50b688e2e49d.
 | ---
 |  fs/anon_inodes.c |    2 +-
 |  1 files changed, 1 insertions(+), 1 deletions(-)

Is lacking pretty much all essential pieces of information which are required 
for reverts:

 - it has no description about who reported the bug.

 - it has no description about what the problem was and what the effects were. 
   People have little chance to link up the 'udev is spinning' bug to
   this fix.

 - it has no link back to '3836a03: anon_inodes: mark the anon inode private' 
   which introduced it and hence it has no -stable tag either.

 - has no signoff line

	Ingo
