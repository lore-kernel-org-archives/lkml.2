Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab0ERMJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 08:09:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:40512 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232Ab0ERMJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 08:09:48 -0400
Date: Tue, 18 May 2010 14:09:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Stephane Chatty <chatty@enac.fr>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, wylda@volny.cz,
       Jerome Vidal <jerom3@free.fr>, Tejun Heo <tj@kernel.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add chardev to propagate special events of Roccat
 hardware to userland
In-Reply-To: <1273383923.2278.17.camel@localhost>
Message-ID: <alpine.LNX.2.00.1005181408140.28092@pobox.suse.cz>
References: <1273161216.2343.6.camel@localhost>  <alpine.LNX.2.00.1005071305350.9849@pobox.suse.cz> <1273383923.2278.17.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 May 2010, Stefan Achatz wrote:

> > >  static void kone_set_settings_checksum(struct kone_settings *settings)
> > > @@ -630,7 +631,7 @@ static ssize_t kone_sysfs_set_startup_profile(struct device *dev,
> > >  static ssize_t kone_sysfs_show_driver_version(struct device *dev,
> > >  		struct device_attribute *attr, char *buf)
> > >  {
> > > -	return snprintf(buf, PAGE_SIZE, DRIVER_VERSION "\n");
> > > +	return snprintf(buf, PAGE_SIZE, ROCCAT_KONE_DRIVER_VERSION "\n");
> > 
> > Do we really want to keep this kind of driver versioning? Git provided 
> > much more fine-graned versioning anyway. What is it needed for?
> 
> My comment to function kone_sysfs_show_driver_version states:
> /*
>  * This file is used by userland software to find devices that are handled by
>  * this driver. This provides a consistent way for actual and older kernels
>  * where this driver replaced usbhid instead of generic-usb.
>  * Driver capabilities are determined by version number.
>  */

Hmm, I don't seem to get it. Is it some kind of ABI versioning? What role 
does legacy usbhid play in it, as it didn't provide this file at all?

> > > +/*
> > > + * Module roccat is a char device used to report special events of roccat
> > > + * hardware to userland. These events include requests for on-screen-display of
> > > + * profile or dpi settings or requests for execution of macro sequences that are
> > > + * not stored in device. The information in these events depends on hid device
> > > + * implementation and contains data that is not available in a single hid event
> > > + * or else hidraw could have been used.
> > > + * It is inspired by hidraw, but uses only one circular buffer for all readers.
> > 
> > This information could maybe go into the kernel changelog as well. For 
> > someone not familiar with the driver layout, the difference between 
> > 'roccat' and 'roccat-kone' might be very difficult to understand.
> 
> How or where do I do this?

Just put it as an "explanation" text accompanying the patch. That will be 
then propagated into the changelog once comitted.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
