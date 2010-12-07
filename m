Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab0LGQXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 11:23:42 -0500
Received: from kroah.org ([198.145.64.141]:59698 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab0LGQXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 11:23:39 -0500
Date: Tue, 7 Dec 2010 08:22:22 -0800
From: Greg KH <greg@kroah.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>
Subject: Re: [RFC][PATCH] input: Introduce device information ioctl
Message-ID: <20101207162222.GA32237@kroah.com>
References: <1291706726-8835-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291706726-8835-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 08:25:26AM +0100, Henrik Rydberg wrote:
>  /**
> + * struct input_devinfo - device information via EVIOCGDEVINFO ioctl
> + * @types: bitmask of types (DEVTYPE_*) matching this device
> + * @capabilities: bitmask of capabilities (DEVCAPS_*) of this device
> + *
> + * This struct provides information about the device needed for
> + * automatic setup in userspace, such as if the device is direct
> + * (touchscreen) or indirect (touchpad), and if there are other
> + * special considerations, such as the touchpad also being a button.
> + */
> +struct input_devinfo {
> +	__u32 types;
> +	__u32 capabilities;
> +};

Why use an ioctl for this at all?  It's just 2 simple values that don't
need to be atomically read at the same time.  What's wrong with 2 more
sysfs files?

thanks,

greg k-h
