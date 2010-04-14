Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab0DNO2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:28:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57702 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752895Ab0DNO2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:28:47 -0400
Date: Wed, 14 Apr 2010 15:32:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Alan Cox <alan@linux.intel.com>, linux-i2c@vger.kernel.org,
       khali@linux-fr.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] hmc6352: Add driver for the HMC6352 compass
Message-ID: <20100414153234.22765666@lxorguk.ukuu.org.uk>
In-Reply-To: <4BC5C7A8.1040807@cam.ac.uk>
References: <20100414124913.23181.75903.stgit@localhost.localdomain>
	<20100414125136.23181.16788.stgit@localhost.localdomain>
	<4BC5C7A8.1040807@cam.ac.uk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is in no way a hwmon chip.  Surely misc is a better location for now
> (pending the usual discussion about all singing all dancing sensors frameworks).

Yep it's moving at the moment


> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/slab.h>
> > +#include <linux/i2c.h>
> > +#include <linux/hwmon.h>
> 
> Why these extra hwmon includes?  At least at first glance I can't see
> any uses of them.  The only call to hwmon is to stick this in the
> hwmon class.

I inherited it for cleanup so these are good points (I've been staring at
piles of these for so long extra input is very useful - this is the tip
of the iceberg !)

> > +#include <linux/hwmon-sysfs.h>
> > +#include <linux/hwmon-vid.h>
> > +#include <linux/err.h>
> > +#include <linux/delay.h>
> or any mutex usage?
> > +#include <linux/mutex.h>
> > +#include <linux/sysfs.h>
> > +
> 
> I guess this makes the driver look like many others, but why bother with
> the wrapping structure?  This is only used to keep track of the hwmon
> device to be able to remove it later.

Should go - agreed will remove

> These address changes looking a little unusual to me.  They may well be needed, but
> if so can we have an explanatory comment?

Will investigate.
