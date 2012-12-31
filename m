Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab2LaDSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 22:18:23 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:48721 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2LaDSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 22:18:20 -0500
Date: Sun, 30 Dec 2012 19:22:00 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dongjin Kim <tobetter@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        =?iso-8859-1?Q?Ren=E9_B=FCrgel?= <rene.buergel@sohard.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] USB: misc: Add USB3503 High-Speed Hub Controller
Message-ID: <20121231032200.GA5769@kroah.com>
References: <1356922268-13098-1-git-send-email-tobetter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356922268-13098-1-git-send-email-tobetter@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2012 at 11:50:54AM +0900, Dongjin Kim wrote:
> This patch adds new driver of SMSC USB3503 USB 2.0 hub controller with HSIC
> upstream connectivity and three USB 2.0 downstream ports. The specification
> can be found from 'http://www.smsc.com/index.php?tid=295&pid=325'.
> 
> The current version have been tested very basic features switching the modes,
> HUB-MODE and STANDBY-MODE.

What causes the modes to be switched?  From reading the driver, that
only seems possible to do at boot/load time when the driver reads the
platform data, right?  After that, nothing happens to the device from
what I can tell.

Is something going to cause the state of the device to change in the
future?

> +		hub->mode = mode;
> +		dev_info(&i2c->dev, "switched to HUB mode\n");

Can you please switch all of the dev_info() calls to dev_dbg()?  There's
no need to tell the world what is going on in this driver, no one really
cares.  And if they do, they can dynamically enable debugging and get
the information then :)

thanks,

greg k-h
