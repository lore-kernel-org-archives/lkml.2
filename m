Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab2KQVyW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 16:54:22 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:35798 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab2KQVyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 16:54:20 -0500
Date: Sat, 17 Nov 2012 13:54:15 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [RFC PATCH 02/06] input/rmi4: Core files
Message-ID: <20121117215415.GA5624@kroah.com>
References: <1353124734-16803-1-git-send-email-cheiny@synaptics.com>
 <1353124734-16803-3-git-send-email-cheiny@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353124734-16803-3-git-send-email-cheiny@synaptics.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 07:58:50PM -0800, Christopher Heiny wrote:
> +static void release_rmidev_device(struct device *dev)
> +{
> +	device_unregister(dev);
> +}

You just leaked memory here, right?

Also, you already unregistered the device, otherwise this function would
have never been called, so you just ended up in a loop?

Have you ever tried removing a device?  Are you sure it's working
properly?

> +EXPORT_SYMBOL(rmi_register_phys_device);

Just curious, but why not EXPORT_SYMBOL_GPL() on all of these new
symbols you are creating?

thanks,

greg k-h
