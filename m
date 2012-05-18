Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965928Ab2ERSwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:52:34 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:21774 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933076Ab2ERSwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:52:33 -0400
Date: Fri, 18 May 2012 20:52:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: anna-maria@glx-um.de, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [patch 20/24] sparc: Use: generic time config
Message-ID: <20120518185230.GA17830@merkur.ravnborg.org>
References: <20120518163020.548627576@glx-um.de> <20120518163106.987564297@glx-um.de> <20120518175041.GA17334@merkur.ravnborg.org> <20120518.135335.1910007668963165501.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518.135335.1910007668963165501.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 01:53:35PM -0400, David Miller wrote:
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Fri, 18 May 2012 19:50:41 +0200
> 
> > On Fri, May 18, 2012 at 04:45:54PM -0000, Anna-Maria Gleixner wrote:
> >> Index: linux/arch/sparc/Kconfig
> >> ===================================================================
> >> --- linux.orig/arch/sparc/Kconfig
> >> +++ linux/arch/sparc/Kconfig
> >> @@ -30,11 +30,13 @@ config SPARC
> >>  	select USE_GENERIC_SMP_HELPERS if SMP
> >>  	select GENERIC_PCI_IOMAP
> >>  	select HAVE_NMI_WATCHDOG if SPARC64
> >> +	select GENERIC_CMOS_UPDATE
> > 
> > I do not see where we define the GENERIC_CMOS_UPDATE symbol,
> > so this looks wrong.
> > 
> > I looked only in upstream - and I did not look
> > in -tip.
> 
> On top of that, I get the impression that this patch series is not
> bisectable at all.

I should be bisectable.

The first patch introduce the symbols with the default value n.
But kconfig will use the "highest" value is see, independent on
the order.

So the following fragment:

config FOO
        def_bool y

config FOO
        bool

config BAR
        bool "BAR"

produces a CONFIG_FOO == y.

And for good measure I also tried with the two
"config FOO" symbols reversed and this produced identical output.

So unless I overlooked something it should be bisectable.

	Sam
