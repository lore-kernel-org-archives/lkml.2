Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2FQXtr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 19:49:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64618 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab2FQXtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 19:49:45 -0400
Date: Sun, 17 Jun 2012 16:49:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC] Plan to get rid of all legacy PM handling
Message-ID: <20120617234940.GB11910@kroah.com>
References: <201206172310.49148.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206172310.49148.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 11:10:49PM +0200, Rafael J. Wysocki wrote:
> Hi all,
> 
> I have a plan to replace all of the legacy device PM callbacks throughout
> the kernel with PM handling based on struct dev_pm_ops objects.  Ultimately,
> that should make it possible to remove the legacy hooks from struct bus_type
> and struct device_driver and to siplify the PM core and some bus types
> (most importantly PCI) quite a bit.
> 
> I'm going to start with platform drivers that should be the most
> straightforward to convert and when they all have been dealt with it
> should be possible to drop the platform bus type's PM callbacks entirely.
> Next, I'm going to take care of the bus types that only define PM callbacks
> to call drivers' callbacks, which is completely unnecessary after some PM
> core changes that went in during the 3.4 development cycle.  Finally, I will
> be looking at PCI drivers.
> 
> The task is huge, but I've done similar things already, so it's nothing new
> to me.  So, if you're a maintainer of code that contains legacy PM handling,
> please be prepared to see some patches from me in a not-too-distant-future.

Nice, that work is great to see have happen, thanks for taking this on,
it's much needed.

greg k-h
