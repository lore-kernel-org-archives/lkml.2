Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab2ISLzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:55:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59488 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab2ISLzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:55:33 -0400
Date: Wed, 19 Sep 2012 13:55:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Kevin Daughtridge <kevin@kdau.com>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: Re: [PATCH v2] HID: leave dev_rdesc unmodified and use it for
 comparisons
In-Reply-To: <50592FB1.7000800@kdau.com>
Message-ID: <alpine.LNX.2.00.1209191354110.31149@pobox.suse.cz>
References: <50592FB1.7000800@kdau.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2012, Kevin Daughtridge wrote:

> The dev_rdesc member of the hid_device structure is meant to store the
> original
> report descriptor received from the device, but it is currently passed to any
> report_fixup method before it is copied to the rdesc member. This patch moves
> the kmemdup to before, not after, the report_fixup call, keeping dev_rdesc
> unchanged.
> 
> usbhid's hid_post_reset checks the report descriptor currently returned by the
> device against a descriptor that may have been modified by a driver's
> report_fixup method. That leaves some devices nonfunctional after a resume,
> with
> a "reset_resume error 1" reported. This patch checks the new descriptor
> against
> the unmodified dev_rdesc instead.
> 
> BugLink:http://bugs.launchpad.net/bugs/1049623
> Signed-off-by: Kevin Daughtridge<kevin@kdau.com>

Your patch is whitespace damaged again, please fix your workload Kevin.

> ---
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -775,12 +775,14 @@ int hid_open_report(struct hid_device *d
>  		return -ENODEV;
>  	size = device->dev_rsize;
>  +	start = kmemdup(start, size, GFP_KERNEL);
> +	if (start == NULL)
> +		return -ENOMEM;
> +

How do you avoid memory leak on 'start' here?

-- 
Jiri Kosina
SUSE Labs
