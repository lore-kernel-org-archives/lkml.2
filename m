Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab0K2Wco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:32:44 -0500
Received: from kroah.org ([198.145.64.141]:49255 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab0K2Wcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:32:43 -0500
Date: Mon, 29 Nov 2010 14:30:30 -0800
From: Greg KH <greg@kroah.com>
To: Timur Tabi <timur@freescale.com>
Cc: Michael Ellerman <michael@ellerman.id.au>, Greg KH <gregkh@suse.de>,
        Scott Wood <scottwood@freescale.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        devicetree-discuss@vger.kernel.org
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101129223030.GA14663@kroah.com>
References: <4CE54E40.9040503@freescale.com>
 <20101118112146.3275eb08@udp111988uds.am.freescale.net>
 <4CE5657D.8060105@freescale.com>
 <20101118121356.3491da72@udp111988uds.am.freescale.net>
 <1290594227.4446.12.camel@concordia>
 <20101124120818.7951bcb4@udp111988uds.am.freescale.net>
 <20101124182353.GA10589@suse.de>
 <1290638647.14502.10.camel@concordia>
 <20101129214439.GA9830@kroah.com>
 <4CF42053.8060801@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF42053.8060801@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 03:51:15PM -0600, Timur Tabi wrote:
> Greg KH wrote:
> >> > + * "Never use this function, bad things will happen" - gregkh
> > Nice, I like it :)
> > 
> > I'll go queue this up.
> 
> How about something a little more descriptive?  You said that the networking
> code can use it.  Could you add some text to explain what the networking code
> does with it, and why it's the only allow caller of this code?

I really don't want to get into it, but the networking code is the only
thing that allows this due to the userspace "want" to rename devices
because we can't create symlinks to network devices like we can for all
other devices (as they use device nodes.)

When this function is called, userspace had better know exactly what is
going on as it can get confused due to the lack of uevents happening.

thanks,

greg k-h
