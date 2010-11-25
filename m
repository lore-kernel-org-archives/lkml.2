Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab0KYPhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:37:20 -0500
Received: from netrider.rowland.org ([192.131.102.5]:51721 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752112Ab0KYPhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:37:19 -0500
Date: Thu, 25 Nov 2010 10:37:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Anton Vorontsov <cbouatmailru@gmail.com>
cc: Lin Mac <mkl0301@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <dbrownell@users.sourceforge.net>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] ARM: cns3xxx: Add architecture definition for
 EHCI/OHCI controller
In-Reply-To: <20101125135614.GA22212@oksana.dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.44L0.1011251031220.22247-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Nov 2010, Anton Vorontsov wrote:

> On Thu, Nov 25, 2010 at 09:51:23PM +0800, Lin Mac wrote:
> > 2010/11/25 Anton Vorontsov <cbouatmailru@gmail.com>:
> > > On Thu, Nov 25, 2010 at 03:25:38PM +0800, Lin Mac wrote:
> > > [...]
> > >> >  #include <linux/module.h>
> > >> >  #include <linux/io.h>
> > >> >  #include <linux/delay.h>
> > >> > +#include <asm/atomic.h>
> > >> It's not necessary for mach/pm.h already included it, right?
> > >
> > > Technically, it's not necessary. But in Linux we don't rely on
> > > headers including other headers.

Just saw this.  Don't be ridiculous -- this happens all over the place.  
People generally aren't aware of it, because it's next to impossible to
verify that all the headers needed by a source file are included
directly.

In fact, there are many cases where it would be considered a _mistake_ 
not to rely on a nested include.  For example, include/linux/spinlock.h 
itself includes many other files which should not be included directly.

> > >  Think that someday mach/pm.h
> > > may not include asm/atomic.h, so the build will break.

Then whoever breaks the build by changing the header file will be
obliged to fix it.

Alan Stern

