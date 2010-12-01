Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab0LATaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:30:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:52880 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756625Ab0LATaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:30:06 -0500
Date: Wed, 1 Dec 2010 11:29:38 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Milton Miller <miltonm@bga.com>, linux-next@vger.kernel.org,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        linux-kernel@vger.kernel.org
Subject: Re: The longest build error ever, ever, ever seen :)
 (Re:linux-next: Tree for November 26)
Message-ID: <20101201192938.GB731@suse.de>
References: <256560.1290881547@localhost>
 <20101127164555.GA23508@suse.de>
 <AANLkTinY3on+arwh-Rvqnbrx_FU4mKDmpwXR_EfkPJ0f@mail.gmail.com>
 <1290927314_21183@mail4.comsite.net>
 <20101201103035.0e0b22cf.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201103035.0e0b22cf.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 10:30:35AM -0800, Randy Dunlap wrote:
> On Sun, 28 Nov 2010 00:55:14 -0600 Milton Miller wrote:
> 
> [also adding linux-next back to cc: list]
> 
> 
> > On Sat Nov 27 2010 around 13:13:03 EST, Valdis Kletnieks wrote:
> > > On Sat, 27 Nov 2010 08:45:55 PST, Greg KH said:
> > > > On Sat, Nov 27, 2010 at 09:56:45AM +0100, Zimny Lech wrote:
> > > > > Ave!
> > > > >
> > > > > 2010/11/26 Stephen Rothwell <sfr@xxxxxxxxxxxxxxxx>:
> > > > > > Hi all,
> > > > > >
> > > > >
> > > > > OMG, LOL, this one is awesome :) The longest build error ever, ever,
> > > > > ever seen! Fscking awesome, someone gets Guiness World Record :)
> > > > >
> > > > > LD drivers/staging/built-in.o
> > > > > drivers/staging/rtl8192e/built-in.o: In function `rtl8192_setBBreg':
> > > > > (.text+0xae00): multiple definition of `rtl8192_setBBreg'
> > > > > drivers/staging/rtl8192u/built-in.o:(.text+0xa1a0): first defined here
> > > >
> > > > You built both of these drivers into the kernel, which causes the
> > > > problem. Try building them as modules, or just one as a module, and
> > > > that will solve the problem.
> > > 
> > > We probably should create some Kconfig magic to prevent this situation?
> > > 
> > > depends (othermodule != 'y') || (myself != 'y')
> > > 
> > > or am I on the wrong track here?
> > > 
> > 
> > A simple
> > 
> > depends on !OTHERMODULE
> > 
> > allows either to be built-in or both to be modular.
> > 
> > It also documents what conflicts.
> > 
> > (see Menu dependencies in Documentation/kbuild/kconfig-language.txt)
> 
> When added for 2 drivers that should not both be built-in, that
> causes this error message:
> 
> drivers/staging/rtl8192u/Kconfig:1:error: recursive dependency detected!
> drivers/staging/rtl8192u/Kconfig:1:     symbol RTL8192U depends on RTL8192E
> drivers/staging/rtl8192e/Kconfig:1:     symbol RTL8192E depends on RTL8192U
> 
> but yes, only one driver is then built-in.

Just make both drivers only able to be built as a module, which will
make everything work properly and all will be happy :)

thanks,

greg k-h
