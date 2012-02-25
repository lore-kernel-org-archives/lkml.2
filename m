Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab2BYPqz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 10:46:55 -0500
Received: from netrider.rowland.org ([192.131.102.5]:48166 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755050Ab2BYPqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 10:46:54 -0500
Date: Sat, 25 Feb 2012 10:46:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: Wolfram Sang <w.sang@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Roland Stigge <stigge@antcom.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kevin.wells@nxp.com>
Subject: Re: [PATCH v2] USB: Support for LPC32xx SoC
In-Reply-To: <201202250845.44427.arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1202251033550.4173-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Feb 2012, Arnd Bergmann wrote:

> On Saturday 25 February 2012, Wolfram Sang wrote:
> > > Unfortunately, the way that ohci handles the abstraction between the
> > > various implementations is backwards, it would be much easier if the
> > > main driver was following that model to start with.
> > 
> > ... exactly for that reason I didn't suggest it. Looking at other ohci-sources
> > (e.g. ohci-omap.c), machine_is_* seems to be the consistent use-case.
> 
> I still hope that someone takes the time to convert ohci and ehci into
> something more regular, building the .c files separately instead of the
> conditional #include "foo.c" inside of the main file.
> 
> Alan and Greg, do you know if anyone is working on that, and if not do you
> think someone should do it?

You are talking about two separate issues.  One is the way the various
bus-glue files get built into the driver, and the other is the way it
#includes .c files.

I don't view the second as a big deal.  A few people have complained
about it, but I don't see the point.  Sure, it has the disadvantage
that you have to recompile the entire driver any time one of the files
is changed.  I can live with that.  It has the advantage that symbols
shared among the source files can be static; they don't have to get
merged into the overall kernel namespace when the driver isn't build as
a module.

The first issue is more serious.  There are long-term plans to
restructure both of those drivers so that the bus glue resides in a
separate module from the main core of the driver.  However I have not
started to work on that yet; there are other more pressing matters to
do first.

It doesn't seem extremely urgent.  Things are working the way they are.  
The main advantage to restructuring is that it would allow distributors
to build bus glue for multiple platforms in a single distribution
image.  Currently that's not possible (except that any one of the
platform glues can be enabled along with the PCI glue).

A little progress has been made already.  We just received a submission
for a "generic" platform bus glue file that will be able to take over
the jobs of several of the existiing files.  If anyone wants to take
this further I won't object, but I don't plan to work on it myself
soon.

Alan Stern

