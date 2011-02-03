Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab1BCKRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 05:17:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab1BCKR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 05:17:29 -0500
Date: Thu, 3 Feb 2011 11:17:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Weber <weber@corscience.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 5/8] HID: roccat: Added ioctl command to retreive report
 size from chardev
In-Reply-To: <1296391105.2283.184.camel@neuromancer>
Message-ID: <alpine.LNX.2.00.1102031116100.2160@pobox.suse.cz>
References: <1296391105.2283.184.camel@neuromancer>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Jan 2011, Stefan Achatz wrote:

> diff --git a/include/linux/roccat.h b/include/linux/roccat.h
> new file mode 100644
> index 0000000..24e1ca0
> --- /dev/null
> +++ b/include/linux/roccat.h
> @@ -0,0 +1,29 @@
> +#ifndef __HID_ROCCAT_H
> +#define __HID_ROCCAT_H
> +
> +/*
> + * Copyright (c) 2010 Stefan Achatz <erazor_de@users.sourceforge.net>
> + */
> +
> +/*
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + */
> +
> +#include <linux/hid.h>
> +#include <linux/types.h>
> +
> +#define ROCCATIOCGREPSIZE _IOR('H', 0xf1, int)
> +
> +#ifdef __KERNEL__
> +
> +int roccat_connect(struct class *klass, struct hid_device *hid,
> +		int report_size);
> +void roccat_disconnect(int minor);
> +int roccat_report_event(int minor, u8 const *data);
> +
> +#endif
> +
> +#endif

I think something like include/linux/hid-roccat.h would be better here.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
