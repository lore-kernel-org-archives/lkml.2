Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab0IBEcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 00:32:11 -0400
Received: from kroah.org ([198.145.64.141]:35214 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab0IBEcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 00:32:09 -0400
Date: Wed, 1 Sep 2010 21:32:54 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        Micha?? Nazarewicz <m.nazarewicz@samsung.com>
Subject: Re: linux-next: build failure after merge of the usb tree
Message-ID: <20100902043254.GB30689@kroah.com>
References: <20100902135450.59d6b96a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902135450.59d6b96a.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 01:54:50PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the usb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/usb/gadget/nokia.c:244: error: unknown field 'bind' specified in initializer
> drivers/usb/gadget/nokia.c:244: warning: initialization makes integer from pointer without a cast
> drivers/usb/gadget/nokia.c:244: error: initializer element is not computable at load time
> drivers/usb/gadget/nokia.c:244: error: (near initialization for 'nokia_driver.needs_serial')
> drivers/usb/gadget/nokia.c: In function 'nokia_init':
> drivers/usb/gadget/nokia.c:250: error: implicit declaration of function 'usb_composite_register'
> 
> Caused by commit cc604fa9db859b7d6899de807d6bd8df80fc0a1a ("usb gadget:
> don't save bind callback in struct usb_configuration").  The 'bind' and
> 'usb_composite_register' references above were added before 2.6.34-rc1
> but missed in this patch.
> 
> Please make every attempt to (at least) build every file that gets
> modified when testing a patch.  (and grep is your friend)
> 
> I have used the usb tree from next-20100901 for today.

Sorry about that, my build didn't catch this.  I'll fix it up tomorrow.

thanks,

greg k-h
