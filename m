Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751039Ab0EIFpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 01:45:31 -0400
Received: from mail-in-18.arcor-online.net ([151.189.21.58]:44348 "EHLO
	mail-in-18.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842Ab0EIFp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 01:45:29 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-02.arcor-online.net 8BB1F11989B
Subject: Re: [PATCH] HID: add chardev to propagate special events of Roccat
 hardware to userland
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephane Chatty <chatty@enac.fr>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, wylda@volny.cz,
       Jerome Vidal <jerom3@free.fr>, Tejun Heo <tj@kernel.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1005071305350.9849@pobox.suse.cz>
References: <1273161216.2343.6.camel@localhost>
	 <alpine.LNX.2.00.1005071305350.9849@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 May 2010 07:45:23 +0200
Message-ID: <1273383923.2278.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 07.05.2010, 13:10 +0200 schrieb Jiri Kosina:
> On Thu, 6 May 2010, Stefan Achatz wrote:
> 
> > This Patch adds a chardev that is used to report special events
> > like request for on-screen-display of actual mouse-setting informations,
> > request for execution of macro sequences not stored in mouse.
> > The device is as generic as possible so that the functionality is usable
> > by all (kone and upcomming) roccat device drivers.
> 
> Hi Stefan,
> 
> what userspace application is supposed to process these events?

Mine. It could be found at http://sourceforge.net/projects/roccat/ 

> > Also small improvements in kone driver are implemented as understanding
> > of the device and kernel programming increases.
> 
> It would be nice to separate those out to standalone patches, please.

Will rerelease as patchset after all points in this mail are addressed.

> > --- a/drivers/hid/hid-roccat-kone.c
> > +++ b/drivers/hid/hid-roccat-kone.c
> > @@ -37,6 +37,7 @@
> >  #include <linux/module.h>
> >  #include <linux/slab.h>
> >  #include "hid-ids.h"
> > +#include "hid-roccat.h"
> >  #include "hid-roccat-kone.h"
> >  
> >  static void kone_set_settings_checksum(struct kone_settings *settings)
> > @@ -630,7 +631,7 @@ static ssize_t kone_sysfs_set_startup_profile(struct device *dev,
> >  static ssize_t kone_sysfs_show_driver_version(struct device *dev,
> >  		struct device_attribute *attr, char *buf)
> >  {
> > -	return snprintf(buf, PAGE_SIZE, DRIVER_VERSION "\n");
> > +	return snprintf(buf, PAGE_SIZE, ROCCAT_KONE_DRIVER_VERSION "\n");
> 
> Do we really want to keep this kind of driver versioning? Git provided 
> much more fine-graned versioning anyway. What is it needed for?

My comment to function kone_sysfs_show_driver_version states:
/*
 * This file is used by userland software to find devices that are handled by
 * this driver. This provides a consistent way for actual and older kernels
 * where this driver replaced usbhid instead of generic-usb.
 * Driver capabilities are determined by version number.
 */

> > new file mode 100644
> > index 0000000..e05d48e
> > --- /dev/null
> > +++ b/drivers/hid/hid-roccat.c
> > @@ -0,0 +1,428 @@
> > +/*
> > + * Roccat driver for Linux
> > + *
> > + * Copyright (c) 2010 Stefan Achatz <erazor_de@users.sourceforge.net>
> > + */
> > +
> > +/*
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License as published by the Free
> > + * Software Foundation; either version 2 of the License, or (at your option)
> > + * any later version.
> > + */
> > +
> > +/*
> > + * Module roccat is a char device used to report special events of roccat
> > + * hardware to userland. These events include requests for on-screen-display of
> > + * profile or dpi settings or requests for execution of macro sequences that are
> > + * not stored in device. The information in these events depends on hid device
> > + * implementation and contains data that is not available in a single hid event
> > + * or else hidraw could have been used.
> > + * It is inspired by hidraw, but uses only one circular buffer for all readers.
> 
> This information could maybe go into the kernel changelog as well. For 
> someone not familiar with the driver layout, the difference between 
> 'roccat' and 'roccat-kone' might be very difficult to understand.

How or where do I do this?

> Thanks,

Also thanks.
Stefan

