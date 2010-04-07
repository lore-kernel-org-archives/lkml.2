Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab0DGP3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:29:30 -0400
Received: from kroah.org ([198.145.64.141]:52662 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521Ab0DGP33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:29:29 -0400
Date: Wed, 7 Apr 2010 08:28:52 -0700
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, Peter Korsgaard <jacmet@sunsite.dk>,
       Rupesh Gujare <rupeshgujare@gmail.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 1/8] USB: composite: allow optional removal of __init
 and __exit tags
Message-ID: <20100407152852.GA13425@kroah.com>
References: <cover.1270644740.git.mina86@mina86.com>
 <033ad254a3bba337e7a37cc6071b7debc7051801.1270644740.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <033ad254a3bba337e7a37cc6071b7debc7051801.1270644740.git.mina86@mina86.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 03:41:28PM +0200, Michal Nazarewicz wrote:
> The composite framework has been written using __init and __exit tags
> to mark init and exit functions as such.  This works with most of the
> composite gadgets however some may need to call init/exit functions
> during normal operations.  One example is mass storage gadget which
> needs to call exit functions.
> 
> This patch allows gadgets to define USB_NO_INIT_SEGMENT or
> USB_NO_EXIT_SEGMENT to remove the __init and __exit declarations
> from composite framework.

Ick ick ick.

How about we just drop the __init and __exit tags completly and then
we don't have to propagate this mess any further?

How much memory do they really save anyway?

I don't like this at all...

thanks,

greg k-h
