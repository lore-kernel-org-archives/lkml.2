Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432Ab0JRWxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 18:53:43 -0400
Received: from mail.perches.com ([173.55.12.10]:3034 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757713Ab0JRWxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 18:53:41 -0400
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
From: Joe Perches <joe@perches.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Daniel Walker <dwalker@fifo99.com>, Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
In-Reply-To: <alpine.LFD.2.00.1010181833440.2764@xanadu.home>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au>
	 <20101018110207.131b56ee.sfr@canb.auug.org.au>
	 <20101018081520.GA10551@flint.arm.linux.org.uk>
	 <1287422792.4105.14.camel@c-dwalke-linux.qualcomm.com>
	 <20101018182044.GA558@flint.arm.linux.org.uk>
	 <1287427572.4105.22.camel@c-dwalke-linux.qualcomm.com>
	 <alpine.LFD.2.00.1010181525000.2764@xanadu.home>
	 <1287432774.5588.5.camel@c-dwalke-linux.qualcomm.com>
	 <20101018205847.GB23642@flint.arm.linux.org.uk>
	 <1287437362.5588.57.camel@c-dwalke-linux.qualcomm.com>
	 <20101018215815.GC23642@flint.arm.linux.org.uk>
	 <1287440826.5588.83.camel@c-dwalke-linux.qualcomm.com>
	 <alpine.LFD.2.00.1010181833440.2764@xanadu.home>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 15:53:38 -0700
Message-ID: <1287442418.5376.38.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 18:35 -0400, Nicolas Pitre wrote:
> On Mon, 18 Oct 2010, Daniel Walker wrote:
> > On Mon, 2010-10-18 at 22:58 +0100, Russell King wrote:
> > > On Mon, Oct 18, 2010 at 02:29:22PM -0700, Daniel Walker wrote:
> > > > That's why we have get_maintainer.pl, it adds in all the CC's
> > > > automatically ..
> > > $ git diff-tree -u 861bd81ee62a0d6759144c22909a8a3938951656 | scripts/get_maintainer.pl |wc 
> > >     209     624    8021
> > > 209 recipients / 8K of To:/CC: is reasonable?
> > What it's showing you is anyone that's ever modified those files.. You
> > just need the people who maintain the files.
> > how about this,
> > git show 08a610d9ef5394525b0328da0162d7b58c982cc4 | ./scripts/get_maintainer.pl | wc
> >      58     163    2169
> > That's the patch we're actually discussing too. It's about one CC per
> > file modified.
> What is a mailing list for, then?  Why are you subscribed?
> Please get real or get away.

Too true.  The patch is entirely for arch/arm and
relatively few if any maintainers need to be cc'd.

This could have been done:

$ git show 08a610d9ef5394525b0328da0162d7b58c982cc4 | ./scripts/get_maintainer.pl --nogit | wc -l
35

Even then, using 35 CCs is generally silly.

It _might_ make some sense for a cover letter and a
patch series where the series made tree-wide changes
in multiple directories.

Even so, lkml will sensibly reject emails with more
than a couple dozen CC's as likely spam.

For cover letters, I generally use:

	./scripts/get_maintainer.pl --nom -l --nogit

and for each patch in a series

	./scripts/get_maintainer.pl --no-git

There is a change in the get_maintainers.pl in Andrew
Morton's mm tree to default to --nogit.

The new get_maintainer.pl is available from:
	git://repo.or.cz/linux-2.6/get_maintainer.git 20100922_gm 
Have a look at:
	http://repo.or.cz/w/linux-2.6/get_maintainer.git


