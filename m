Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab0IBUMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:12:50 -0400
Received: from kroah.org ([198.145.64.141]:57305 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756813Ab0IBULr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:11:47 -0400
Date: Thu, 2 Sep 2010 13:01:57 -0700
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Stephen Rotwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] usb gadget: don't save bind callback in struct
 usb_composite_driver
Message-ID: <20100902200157.GB16897@kroah.com>
References: <20100902135450.59d6b96a.sfr@canb.auug.org.au>
 <fd8a8c411073c30df87c273da283c9b7eebfe872.1283403154.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fd8a8c411073c30df87c273da283c9b7eebfe872.1283403154.git.mina86@mina86.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 07:33:08AM +0200, Michal Nazarewicz wrote:
> The bind function is most of the time only called at init time so there
> is no need to save a pointer to it in the composite driver structure.
> 
> This fixes many section mismatches reported by modpost.
> 
> Signed-off-by: Michał Nazarewicz <m.nazarewicz@samsung.com>
> Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/usb/gadget/audio.c        |    3 +--
>  drivers/usb/gadget/cdc2.c         |    3 +--
>  drivers/usb/gadget/composite.c    |   15 +++++++++++----
>  drivers/usb/gadget/ether.c        |    3 +--
>  drivers/usb/gadget/g_ffs.c        |    3 +--
>  drivers/usb/gadget/hid.c          |    3 +--
>  drivers/usb/gadget/mass_storage.c |    3 +--
>  drivers/usb/gadget/multi.c        |    3 +--
>  drivers/usb/gadget/nokia.c        |    3 +--
>  drivers/usb/gadget/serial.c       |    3 +--
>  drivers/usb/gadget/webcam.c       |    3 +--
>  drivers/usb/gadget/zero.c         |    3 +--
>  include/linux/usb/composite.h     |   19 +++++--------------
>  13 files changed, 27 insertions(+), 40 deletions(-)
> 
> On Thu, 02 Sep 2010 05:54:50 +0200, Stephen Rothwell wrote:
> > After merging the usb tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >
> > drivers/usb/gadget/nokia.c:244: error: unknown field 'bind' specified in initializer
> > drivers/usb/gadget/nokia.c:244: warning: initialization makes integer from pointer without a cast
> > drivers/usb/gadget/nokia.c:244: error: initializer element is not computable at load time
> > drivers/usb/gadget/nokia.c:244: error: (near initialization for 'nokia_driver.needs_serial')
> > drivers/usb/gadget/nokia.c: In function 'nokia_init':
> > drivers/usb/gadget/nokia.c:250: error: implicit declaration of function 'usb_composite_register'
> >
> > Caused by commit cc604fa9db859b7d6899de807d6bd8df80fc0a1a ("usb gadget:
> > don't save bind callback in struct usb_configuration").  The 'bind' and
> > 'usb_composite_register' references above were added before 2.6.34-rc1
> > but missed in this patch.
> 
> Sorry about that.  Nokia composite gadget requires Phonet and that's
> why I failed to catch this error.  (Truly, grep would probably work
> better).
> 
> Attached is an updated patch that takes nokia.c into consideration as
> well. Greg, please replace the non-working version of the patch in
> your tree with this one.

Now replaced, thanks.

greg k-h
