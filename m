Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1JZViY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 17:38:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab1JZViV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 17:38:21 -0400
Date: Wed, 26 Oct 2011 23:38:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Domenico Andreoli <cavokz@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [GIT PATCH] TTY/serial driver patches for 3.2
In-Reply-To: <20111026141635.GA2293@glitch>
Message-ID: <alpine.LRH.2.00.1110262335300.24704@twin.jikos.cz>
References: <20111026114236.GA22180@kroah.com> <CA+55aFycM+nHxJNnFSjEXQvZkeBfHu161ePC0=7sWKZR1toQNA@mail.gmail.com> <20111026133438.GA26336@suse.de> <20111026141635.GA2293@glitch>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Oct 2011, Domenico Andreoli wrote:

> > > > The one in 8250_pci.c is trivial to fix, the atmel_serial one isn't as
> > > > easy, but I'm sure you can figure it out :)  If you want me to do the
> > > > merge for it, I'll be glad to do so, just let me know.
> > > 
> > > So I figured it out, but please double-check, especially since it
> > > seems to be some arm-only driver that I can't even compile-test my
> > > resolution.
> > 
> > I think it looks correct, but yeah, as I can't build it either, it's
> > tough to tell.
> > 
> > Nicolas, can you verify that Linus's merge was done correctly?  If not,
> > can you send a patch?  It is commit
> > efb8d21b2c6db3497655cc6a033ae8a9883e4063 in Linus's tree right now.
> 
> tryed to build efb8d21 with at91cap9adk_defconfig + DT + 8250 but it fails:
> 
> drivers/tty/serial/atmel_serial.c: In function 'atmel_serial_probe':
> drivers/tty/serial/atmel_serial.c:1788:3: error: implicit declaration of function 'of_alias_get_id' [-Werror=implicit-function-declaration]
> drivers/tty/serial/atmel_serial.c: At top level:
> drivers/tty/serial/atmel_serial.c:1893:3: error: implicit declaration of function 'of_match_ptr' [-Werror=implicit-function-declaration]
> drivers/tty/serial/atmel_serial.c:1893:3: error: initializer element is not constant
> drivers/tty/serial/atmel_serial.c:1893:3: error: (near initialization for 'atmel_serial_driver.driver.of_match_table')
> cc1: some warnings being treated as errors
> 
> there is not mention of such (new) of_match_ptr macro anywhere in Linus' tree.

Yes, it's depending on this one, which I believe is queued in Grant's tree 
but not yet merged:

	commit 3a1e362e3f3cd571b3974b8d44b8e358ec7a098c
	Author: Ben Dooks <ben-linux@fluff.org>
	Date:   Wed Aug 3 10:11:42 2011 +0100

	    OF: Add of_match_ptr() macro
	    
	    Add a macro of_match_ptr() that allows the .of_match_table
	    entry in the driver structures to be assigned without having
	    an #ifdef xxx NULL for the case that OF is not enabled
	    
	    Signed-off-by: Ben Dooks <ben-linux@fluff.org>
	    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

-- 
Jiri Kosina
SUSE Labs

