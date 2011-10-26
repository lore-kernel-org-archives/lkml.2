Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab1JZOQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 10:16:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48072 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab1JZOQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 10:16:40 -0400
Date: Wed, 26 Oct 2011 16:16:35 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [GIT PATCH] TTY/serial driver patches for 3.2
Message-ID: <20111026141635.GA2293@glitch>
Mail-Followup-To: Greg KH <gregkh@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
References: <20111026114236.GA22180@kroah.com>
 <CA+55aFycM+nHxJNnFSjEXQvZkeBfHu161ePC0=7sWKZR1toQNA@mail.gmail.com>
 <20111026133438.GA26336@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111026133438.GA26336@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 03:34:38PM +0200, Greg KH wrote:
> On Wed, Oct 26, 2011 at 03:18:21PM +0200, Linus Torvalds wrote:
> > On Wed, Oct 26, 2011 at 1:42 PM, Greg KH <gregkh@suse.de> wrote:
> > >
> > > The one in 8250_pci.c is trivial to fix, the atmel_serial one isn't as
> > > easy, but I'm sure you can figure it out :)  If you want me to do the
> > > merge for it, I'll be glad to do so, just let me know.
> > 
> > So I figured it out, but please double-check, especially since it
> > seems to be some arm-only driver that I can't even compile-test my
> > resolution.
> 
> I think it looks correct, but yeah, as I can't build it either, it's
> tough to tell.
> 
> Nicolas, can you verify that Linus's merge was done correctly?  If not,
> can you send a patch?  It is commit
> efb8d21b2c6db3497655cc6a033ae8a9883e4063 in Linus's tree right now.

tryed to build efb8d21 with at91cap9adk_defconfig + DT + 8250 but it fails:

drivers/tty/serial/atmel_serial.c: In function 'atmel_serial_probe':
drivers/tty/serial/atmel_serial.c:1788:3: error: implicit declaration of function 'of_alias_get_id' [-Werror=implicit-function-declaration]
drivers/tty/serial/atmel_serial.c: At top level:
drivers/tty/serial/atmel_serial.c:1893:3: error: implicit declaration of function 'of_match_ptr' [-Werror=implicit-function-declaration]
drivers/tty/serial/atmel_serial.c:1893:3: error: initializer element is not constant
drivers/tty/serial/atmel_serial.c:1893:3: error: (near initialization for 'atmel_serial_driver.driver.of_match_table')
cc1: some warnings being treated as errors

there is not mention of such (new) of_match_ptr macro anywhere in Linus' tree.

Regards,
Domenico
