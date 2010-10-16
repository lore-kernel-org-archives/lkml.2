Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab0JPWOm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 18:14:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52854 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab0JPWOl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 18:14:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christian Casteyde <casteyde.christian@free.fr>
Subject: Re: [Bug #17361] Random kmemcheck errors and kernel freeze on 2.6.36-rc*
Date: Sun, 17 Oct 2010 00:13:36 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc8-rjw+; KDE/4.4.4; x86_64; ; )
References: <v0Rsc8XZnFC.A.-xF.oqfsMB@chimera> <201010102140.26584.rjw@sisk.pl> <201010112330.35921.casteyde.christian@free.fr>
In-Reply-To: <201010112330.35921.casteyde.christian@free.fr>
MIME-Version: 1.0
Cc: LKML <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010170013.36208.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 11, 2010, Christian Casteyde wrote:
> Hello

Hi,

> Well, I would like to find the real commit, but I don't know how to do that.
> I'm not so used to using other branches than Linus' one.
> 
> From the commit hash, how do I find:
> - the git tree I should use to bisect more?
> - the initial good and bad marks?
> And can I bisect only that branch on top of my current kernel source directory?

Yes, you can.  In this particular case the merge says that the series started
with commit "x86: Fix keeping track of AMD C1E" and ended with
"x86, xsave: Cleanup return codes in check_for_xstate()".

Now, you can do

$ git log --oneline v2.6.35.. | grep "x86: Fix keeping track of AMD C1E"

and you get this information:

e8c534e x86: Fix keeping track of AMD C1E

Similarly, this command

$ git log --oneline v2.6.35.. | grep "x86, xsave: Cleanup return codes in check_for_xstate()"

returns

d6d4d42 x86, xsave: Cleanup return codes in check_for_xstate()

so you probably need to bisect between commits d6d4d42 (presumably good)
and e8c534e (presumably bad).

However, it still is better to do "checkout d6d4d42" and see if that kernel is
good (and analogously for d6d4d42) to start with.

Thanks,
Rafael


> Le dimanche 10 octobre 2010 21:40:26, vous avez écrit :
> > On Sunday, October 10, 2010, Christian Casteyde wrote:
> > > Still present with 2.6.37-rc7
> > > I think I managed to bisect it however:
> > > 
> > > 0f477dd0851bdcee82923da66a7fc4a44cb1bc3d is the first bad commit
> > 
> > This is a merge, so it most likely is not the real first bad commit.
> > 
> > Could you check the commits on the branch merged by it?
> > 
> > Rafael
> 
> 

