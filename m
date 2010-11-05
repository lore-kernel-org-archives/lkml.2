Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0KESBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 14:01:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:52189 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970Ab0KESBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:01:48 -0400
Date: Fri, 5 Nov 2010 14:01:42 -0400 (EDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Stephane Chatty <chatty@enac.fr>,
        Don Prince <dhprince-devel@yahoo.co.uk>,
        Dmitry Torokhov <dtor@mail.ru>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] HID: roccat: Add support for Roccat Kone[+]
In-Reply-To: <1288978962.2585.15.camel@neuromancer>
Message-ID: <alpine.LNX.2.00.1011051400250.15851@pobox.suse.cz>
References: <1287943025.2623.16.camel@neuromancer>  <alpine.LNX.2.00.1011041418530.15851@pobox.suse.cz> <1288978962.2585.15.camel@neuromancer>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Nov 2010, Stefan Achatz wrote:

> > > This patch adds support for Roccat Kone[+] gaming mouse. Kone[+] is an enhanced version
> > > of the old Kone with more memory for macros, a better sensor and more functionality.
> > > This driver is conceptual similar to the existing Kone and Pyra drivers.
> > > Userland tools can soon be found at http://sourceforge.net/projects/roccat
> > 
> > Seems like there is a lot of duplicate code with Roccat Kone.
> > Is there any reason this couldn't be merged with the Roccat Kone 
> > counterparts?
> 
> In fact the Kone[+] seems to be nearer to the Pyra than the old Kone.
> Looks like the manufacturer changed the firmware programmer between some
> devices. I wanted to wait until I see more devices of this manufacturer
> if some kind of genealogy might be visible and remove code duplication
> based on that.

It would be really nice, otherwise this gets into unmaintainable mess very 
quickly.

> > > +static ssize_t koneplus_sysfs_read_profile5_settings(struct file *fp,
> > > +		struct kobject *kobj, struct bin_attribute *attr, char *buf,
> > > +		loff_t off, size_t count)
> > > +{
> > > +	return koneplus_sysfs_read_profilex_settings(fp, kobj,
> > > +			attr, buf, off, count, 4);
> > > +}
> > > +
> > 
> > This is really ugly. Can't you have just one read() function and 
> > distuingish according to bin_attribute->private?
> 
> The patch comes in a view moments, if you like it I'll do the same for
> Kone and Pyra.

Would be nice, thanks for fixing it.

> > > + * Copyright (c) 2010 Stefan Achatz <erazor_de@users.sourceforge.net>
> > > + */
> > > +
> > > +/*
> > > + * This program is free software; you can redistribute it and/or modify it
> > > + * under the terms of the GNU General Public License as published by the Free
> > > + * Software Foundation; either version 2 of the License, or (at your option)
> > > + * any later version.
> > > + */
> > > +
> > > +#include <linux/types.h>
> > > +
> > > +#pragma pack(push)
> > > +#pragma pack(1)
> > 
> > Why?
> 
> What?

I would prefer to have comments there, explaining why those pragmas are 
necessary.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
