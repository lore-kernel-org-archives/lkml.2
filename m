Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab1AaW7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:59:09 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54579 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab1AaW7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:59:07 -0500
Date: Mon, 31 Jan 2011 15:59:02 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH] Power domains for platform bus type
Message-ID: <20110131225902.GD27856@angua.secretlab.ca>
References: <201101300107.19389.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101300107.19389.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 30, 2011 at 01:07:19AM +0100, Rafael J. Wysocki wrote:
> Hi,
> 
> This is something we discussed during the last Linux Plumbers Conference.
> 
> The problem appears to be that the same device may be used in different
> systems in different configurations such that actions necessary for the
> device's power management can vary from one system to another.  In those
> cases the drivers' power management callbacks are generally not sufficient,
> because they can't take the configuration of the whole system into account.
> 
> I think this issue may be addressed by adding objects that will represent
> power domains and will provide power management callbacks to be executed
> in addition to the device driver's PM callbacks, which is done by the patch
> below.
> 
> Please have a look at it and tell me what you think.

In general it looks okay.  I agree with Alan's comment that it
probably belongs outside the platform device pm ops.  It's the sort of
thing that should be available to *any* device, regardless of bus
type.  ie. it is conceivable that some spi and i2c devices would be in
need to be in the same power_domain.

It slightly worries me about the amount of code required to manage all the
nested levels of pm_ops.  I wonder if there is a better way to manage
them.

Also, what is the use case for having 2 sets of power_domain ops?  My
gut tells me that you'd only want to do post ops on the
{freeze,suspend,poweroff} path and pre ops on the {resume,thaw,restore}
path.  It seems overly engineered to me, but I may be missing
something fundamental.

g.

