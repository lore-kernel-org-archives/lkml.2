Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab1EBD2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 23:28:30 -0400
Received: from kroah.org ([198.145.64.141]:39774 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab1EBD22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 23:28:28 -0400
Date: Sun, 1 May 2011 20:29:06 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <rdunlap@xenotime.net>, wanlong.gao@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the over time interface of the driver-model docs
Message-ID: <20110502032906.GA1553@kroah.com>
References: <1304229056-5554-1-git-send-email-wanlong.gao@gmail.com>
 <20110501195939.c0ae66cc.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501195939.c0ae66cc.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 07:59:39PM -0700, Randy Dunlap wrote:
> On Sun,  1 May 2011 13:50:56 +0800 wanlong.gao@gmail.com wrote:
> 
> > From: Wanlong Gao<wanlong.gao@gmail.com>
> > 
> > The driver-model documentation seems like out-of-date, Can we
> > fix them or rewrite ?
> 
> GregKH should get this patch.......
> 
> 
> > Signed-off-by: Wanlong Gao<wanlong.gao@gmail.com>
> > ---
> >  Documentation/driver-model/bus.txt    |   32 ++++----
> >  Documentation/driver-model/device.txt |  149 +++++++++++++++++++--------------
> >  2 files changed, 104 insertions(+), 77 deletions(-)
> > 
> > diff --git a/Documentation/driver-model/bus.txt b/Documentation/driver-model/bus.txt
> > index 5001b75..82bca26 100644
> > --- a/Documentation/driver-model/bus.txt
> > +++ b/Documentation/driver-model/bus.txt
> > @@ -5,21 +5,23 @@ Definition
> >  ~~~~~~~~~~
> >  
> >  struct bus_type {
> > -	char			* name;
> > +	const char		*name;
> > +	struct bus_attribute	*bus_attrs;
> > +	struct device_attribute	*dev_attrs;
> > +	struct driver_attribute	*drv_attrs;


<snip>

This should almost all removed from these files and moved to be
kerneldoc in the device.h file instead.  That will keep things up to
date and provide a better way to document this stuff.

Wanlong, can you do that instead?

thanks,

greg k-h
