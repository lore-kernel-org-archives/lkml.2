Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab2BYTTM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 14:19:12 -0500
Received: from lunge.queued.net ([173.255.254.236]:53762 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840Ab2BYTTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 14:19:10 -0500
Date: Sat, 25 Feb 2012 11:19:05 -0800
From: Andres Salomon <dilinger@queued.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Fox <pgf@laptop.org>,
        Martin Langhoff <martin@laptop.org>
Subject: Re: [PATCH] input: psmouse:  create an 'enabled' sysfs attribute to
 squelch mouse
Message-ID: <20120225111905.4b8ae970@debxo>
In-Reply-To: <20120224082158.GA18291@core.coreip.homeip.net>
References: <20120217180634.6162196e@debxo>
	<20120224082158.GA18291@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012 00:21:58 -0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> Hi Andres,
> 
> On Fri, Feb 17, 2012 at 06:06:34PM -0800, Andres Salomon wrote:
> > 
> > From: Paul Fox <pgf@laptop.org>
> > 
> > on OLPC XO laptops, at least one model of touchpad (sentelic)
> > emits continuous jittery motion reports when the laptop is
> > configured in "ebook" mode.  the touchpad is inaccessible in
> > that configuration, so we simply disable it.
> > 
> > these motion reports will wake the SoC when put to sleep, so simply
> > ignoring the events is not a possibilty; the device must be
> > disabled.
> 
> Can you switch the AUX serio port into manual bind mode (viqa sysfs)
> and simply connect/disconnect the touchpad as needed (again via
> sysfs)?
> 

Thanks for the suggestion.  We're in the process of testing that; it
does stop the touchpad from transmitting data, but there are some
reinit issues to be investigated.  Quoth pgf, "the added latency
due to the reinit when we enter/exit ebook mode might or might not be
acceptable.  and our touchpad (sentelic) needs some boot time
initialization from user-level -- we're not sure whether we'll need
to redo some or all of that.  (we do seem to lose the current values of
vscroll and hscroll, for instance.)"
