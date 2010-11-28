Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab0K1AVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 19:21:50 -0500
Received: from cantor.suse.de ([195.135.220.2]:49217 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765Ab0K1AVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 19:21:47 -0500
Date: Sat, 27 Nov 2010 16:22:28 -0800
From: Greg KH <gregkh@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Valdis.Kletnieks@vt.edu, Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andres More <more.andres@gmail.com>,
        Charles Cl?ment <caratorn@gmail.com>, devel@driverdev.osuosl.org,
        Mike McCormack <mikem@ring3k.org>, Radu Voicilas <rvoicilas@gmail.com>
Subject: Re: The longest build error ever, ever, ever seen :) (Re:
 linux-next: Tree for November 26)
Message-ID: <20101128002228.GB4562@suse.de>
References: <AANLkTinY3on+arwh-Rvqnbrx_FU4mKDmpwXR_EfkPJ0f@mail.gmail.com>
 <20101127164555.GA23508@suse.de>
 <256560.1290881547@localhost>
 <20101127182723.GA5389@suse.de>
 <20101128082126.eca68e5b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101128082126.eca68e5b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 28, 2010 at 08:21:26AM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Sat, 27 Nov 2010 10:27:23 -0800 Greg KH <gregkh@suse.de> wrote:
> >
> > On Sat, Nov 27, 2010 at 01:12:27PM -0500, Valdis.Kletnieks@vt.edu wrote:
> > > On Sat, 27 Nov 2010 08:45:55 PST, Greg KH said:
> > > > On Sat, Nov 27, 2010 at 09:56:45AM +0100, Zimny Lech wrote:
> > > > > Ave!
> > > > > 
> > > > > 2010/11/26 Stephen Rothwell <sfr@canb.auug.org.au>:
> > > > > > Hi all,
> > > > > >
> > > > > 
> > > > > OMG, LOL, this one is awesome :) The longest build error ever, ever,
> > > > > ever seen! Fscking awesome, someone gets Guiness World Record :)
> > > > > 
> > > > >   LD      drivers/staging/built-in.o
> > > > > drivers/staging/rtl8192e/built-in.o: In function `rtl8192_setBBreg':
> > > > > (.text+0xae00): multiple definition of `rtl8192_setBBreg'
> > > > > drivers/staging/rtl8192u/built-in.o:(.text+0xa1a0): first defined here
> > > > 
> > > > You built both of these drivers into the kernel, which causes the
> > > > problem.  Try building them as modules, or just one as a module, and
> > > > that will solve the problem.
> > > 
> > > We probably should create some Kconfig magic to prevent this situation?
> > > 
> > > 	depends (othermodule != 'y') || (myself != 'y')
> > > 
> > > or am I on the wrong track here?
> > 
> > Just make each module depend on 'm' so that they can not be built into
> > the kernel, and all should be fine.
> 
> Surely the real fix is to make sure that the global symbols in these
> drivers are unique ...

That would be "ideal" if they both weren't carrying pretty much the
identical wireless stack within them :)

That's a longer-term fix, the "only build as a module" is common for
staging drivers for this very reason.

thanks,

greg k-h
