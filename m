Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab0FNQ3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:29:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:41344 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab0FNQ3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:29:36 -0400
Date: Mon, 14 Jun 2010 09:29:19 -0700
From: Greg KH <gregkh@suse.de>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-usb@vger.kernel.org,
       Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] khubd -- switch USB product/manufacturer/serial
 handling to RCU
Message-ID: <20100614162919.GA13932@suse.de>
References: <1276514141-23725-1-git-send-email-apw@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276514141-23725-1-git-send-email-apw@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 12:15:41PM +0100, Andy Whitcroft wrote:
> With the introduction of wireless USB hubs the product, manufacturer,
> and serial number are now mutable.

Changable by whom?  The device itself?  This has always been the case,
although it is usually very rare for a device to do this.

> This necessitates new locking in the gconsumers of these values
> including the sysfs read routines in order to prevent use-after-free
> acces to these values.

Who would access them after they go away?

> These extra locks create significant lock contention leading to
> increased boot times (0.3s for an example Atom based system).

Who is doing all of the deauthorization at boot time that this would
ever matter at all?

> Move update of these values to RCU based locking.

Ick.  What has changed that necessitates this?  You discuss a variety of
different things in this bug report:

> BugLink: http://bugs.launchpad.net/bugs/510937

Which would have been nice to dicuss with the people on these lists.  I
really don't think this is the correct fix, as a normal boot path
shouldn't be having non-authorized usb devices, right?  And from that
bug, once the machine is up and running, there is no contention here,
right?

not convinced,

greg k-h
