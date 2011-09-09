Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607Ab1IIS0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 14:26:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57609 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab1IIS0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 14:26:47 -0400
Date: Fri, 9 Sep 2011 09:28:13 -0700
From: Greg KH <gregkh@suse.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Donggeun Kim <dg77.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, akpm@linux-foundation.org, jic23@cam.ac.kr,
        kyungmin.park@samsung.com
Subject: Re: [PATCH v2] misc: Add driver for GP2AP002 proximity/ambient light
 sensor
Message-ID: <20110909162813.GA28470@suse.de>
References: <1315556546-7445-1-git-send-email-dg77.kim@samsung.com>
 <20110909083134.GA21835@suse.de>
 <4E69D968.2020100@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E69D968.2020100@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 10:16:24AM +0100, Jonathan Cameron wrote:
> On 09/09/11 09:31, Greg KH wrote:
> > On Fri, Sep 09, 2011 at 05:22:26PM +0900, Donggeun Kim wrote:
> >> SHARP GP2AP002 is proximity and ambient light sensor.
> >> This patch supports it.
> >>
> >> Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >> Changes for v2
> >>   - changed to expose lux
> >>   - changed request_irq to request_threaded_irq function
> >>   - added sysfs_notify function call
> > 
> > Why?  You should never do that unless you _really_ know what you are
> > doing.
> My bad.  I suggested it was a better bet than doing a uevent to act
> as a data ready notifier...
> 
> Greg, for future reference can you clarify why it's a bad idea or
> give a reference (if it's been clarified elsewhere and I missed it!)

uevents are not for general "this sensor changed" type events.  They are
for "large" events like "your laptop got docked, your disk got removed,
etc."

They can be very "heavy" so don't use them lightly,

greg k-h
