Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab0LASat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:30:49 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:63729 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab0LASas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:30:48 -0500
Date: Wed, 1 Dec 2010 10:30:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Milton Miller <miltonm@bga.com>, linux-next@vger.kernel.org
Cc: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>, Greg KH <gregkh@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: The longest build error ever, ever, ever seen :)
 (Re:linux-next: Tree for November 26)
Message-Id: <20101201103035.0e0b22cf.randy.dunlap@oracle.com>
In-Reply-To: <1290927314_21183@mail4.comsite.net>
References: <256560.1290881547@localhost>
	<20101127164555.GA23508@suse.de>
	<AANLkTinY3on+arwh-Rvqnbrx_FU4mKDmpwXR_EfkPJ0f@mail.gmail.com>
	<1290927314_21183@mail4.comsite.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Nov 2010 00:55:14 -0600 Milton Miller wrote:

[also adding linux-next back to cc: list]


> On Sat Nov 27 2010 around 13:13:03 EST, Valdis Kletnieks wrote:
> > On Sat, 27 Nov 2010 08:45:55 PST, Greg KH said:
> > > On Sat, Nov 27, 2010 at 09:56:45AM +0100, Zimny Lech wrote:
> > > > Ave!
> > > >
> > > > 2010/11/26 Stephen Rothwell <sfr@xxxxxxxxxxxxxxxx>:
> > > > > Hi all,
> > > > >
> > > >
> > > > OMG, LOL, this one is awesome :) The longest build error ever, ever,
> > > > ever seen! Fscking awesome, someone gets Guiness World Record :)
> > > >
> > > > LD drivers/staging/built-in.o
> > > > drivers/staging/rtl8192e/built-in.o: In function `rtl8192_setBBreg':
> > > > (.text+0xae00): multiple definition of `rtl8192_setBBreg'
> > > > drivers/staging/rtl8192u/built-in.o:(.text+0xa1a0): first defined here
> > >
> > > You built both of these drivers into the kernel, which causes the
> > > problem. Try building them as modules, or just one as a module, and
> > > that will solve the problem.
> > 
> > We probably should create some Kconfig magic to prevent this situation?
> > 
> > depends (othermodule != 'y') || (myself != 'y')
> > 
> > or am I on the wrong track here?
> > 
> 
> A simple
> 
> depends on !OTHERMODULE
> 
> allows either to be built-in or both to be modular.
> 
> It also documents what conflicts.
> 
> (see Menu dependencies in Documentation/kbuild/kconfig-language.txt)

When added for 2 drivers that should not both be built-in, that
causes this error message:

drivers/staging/rtl8192u/Kconfig:1:error: recursive dependency detected!
drivers/staging/rtl8192u/Kconfig:1:     symbol RTL8192U depends on RTL8192E
drivers/staging/rtl8192e/Kconfig:1:     symbol RTL8192E depends on RTL8192U

but yes, only one driver is then built-in.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
