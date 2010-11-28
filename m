Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab0K1GzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 01:55:18 -0500
Received: from mail4.comsite.net ([205.238.176.238]:11495 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab0K1GzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 01:55:15 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=98.194.216.198;
From: Milton Miller <miltonm@bga.com>
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>, Greg KH <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: The longest build error ever, ever, ever seen :) (Re:linux-next: Tree for November 26)
In-Reply-To: <256560.1290881547@localhost>
References: <256560.1290881547@localhost>
	<20101127164555.GA23508@suse.de>
	<AANLkTinY3on+arwh-Rvqnbrx_FU4mKDmpwXR_EfkPJ0f@mail.gmail.com>
Date: Sun, 28 Nov 2010 00:55:14 -0600
X-Originating-IP: 98.194.216.198
Message-ID: <1290927314_21183@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat Nov 27 2010 around 13:13:03 EST, Valdis Kletnieks wrote:
> On Sat, 27 Nov 2010 08:45:55 PST, Greg KH said:
> > On Sat, Nov 27, 2010 at 09:56:45AM +0100, Zimny Lech wrote:
> > > Ave!
> > >
> > > 2010/11/26 Stephen Rothwell <sfr@xxxxxxxxxxxxxxxx>:
> > > > Hi all,
> > > >
> > >
> > > OMG, LOL, this one is awesome :) The longest build error ever, ever,
> > > ever seen! Fscking awesome, someone gets Guiness World Record :)
> > >
> > > LD drivers/staging/built-in.o
> > > drivers/staging/rtl8192e/built-in.o: In function `rtl8192_setBBreg':
> > > (.text+0xae00): multiple definition of `rtl8192_setBBreg'
> > > drivers/staging/rtl8192u/built-in.o:(.text+0xa1a0): first defined here
> >
> > You built both of these drivers into the kernel, which causes the
> > problem. Try building them as modules, or just one as a module, and
> > that will solve the problem.
> 
> We probably should create some Kconfig magic to prevent this situation?
> 
> depends (othermodule != 'y') || (myself != 'y')
> 
> or am I on the wrong track here?
> 

A simple

depends on !OTHERMODULE

allows either to be built-in or both to be modular.

It also documents what conflicts.

(see Menu dependencies in Documentation/kbuild/kconfig-language.txt)

milton
