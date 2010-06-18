Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542Ab0FROqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 10:46:10 -0400
Received: from kroah.org ([198.145.64.141]:52733 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758020Ab0FROqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 10:46:08 -0400
Date: Fri, 18 Jun 2010 07:39:01 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 06/11] USB: gadget: g_multi: code clean up and
 refactoring
Message-ID: <20100618143901.GA16413@kroah.com>
References: <20100615185527.GA22803@kroah.com>
 <cover.1276681840.git.m.nazarewicz@samsung.com>
 <7131891c93ac20a3360068e2f4b8fff0de7dfafb.1276681840.git.m.nazarewicz@samsung.com>
 <1cf0484e46e3b2b5ce0dea8cdc7396d4bfa977c5.1276681840.git.m.nazarewicz@samsung.com>
 <0022e21e1b622b3a54d1e55aed727e7e429c7c70.1276681840.git.m.nazarewicz@samsung.com>
 <45fc10256bd2374706e4153360427257d15804a9.1276681840.git.m.nazarewicz@samsung.com>
 <bb0d9f73c7caae31c0bc291d3dfce44a2f6a3736.1276681840.git.m.nazarewicz@samsung.com>
 <c7fbb2934e18cfd25df3e00a548ac33e5b0a7353.1276681840.git.m.nazarewicz@samsung.com>
 <20100617175101.GD3644@kroah.com>
 <op.vehrh0lu7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vehrh0lu7p4s8u@pikus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 12:31:02PM +0200, Michał Nazarewicz wrote:
> On Thu, 17 Jun 2010 19:51:01 +0200, Greg KH <greg@kroah.com> wrote:
> 
> >On Wed, Jun 16, 2010 at 12:08:01PM +0200, Michal Nazarewicz wrote:
> >>The Multifunction Compasite Gadget have been cleaned up
> >>and refactored so hopefully it looks prettier and works
> >>at least as good as before changes.
> >>
> >>Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> >>Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>---
> >> drivers/usb/gadget/Kconfig |    1 +
> >> drivers/usb/gadget/multi.c |  262 +++++++++++++++++++++++++-------------------
> >> 2 files changed, 148 insertions(+), 115 deletions(-)
> >>
> >>diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> >>index 591ae9f..027f61b 100644
> >>--- a/drivers/usb/gadget/Kconfig
> >>+++ b/drivers/usb/gadget/Kconfig
> >>@@ -863,6 +863,7 @@ config USB_G_NOKIA
> >> config USB_G_MULTI
> >> 	tristate "Multifunction Composite Gadget (EXPERIMENTAL)"
> >> 	depends on BLOCK && NET
> >>+	select USB_G_MULTI_CDC if !USB_G_MULTI_RNDIS
> >> 	help
> >> 	  The Multifunction Composite Gadget provides Ethernet (RNDIS
> >> 	  and/or CDC Ethernet), mass storage and ACM serial link
> >
> >Why is this change needed?  Did you do something else in this patch that
> >requires it?
> 
> Without this select it is possible to choose neither RNDIS nor CDC ECM which
> in turns builds a module with no configurations.

Then you need to say that in the changelog portion of the patch
submission :)

thanks,

greg k-h
