Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299Ab1KHUcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 15:32:06 -0500
Received: from host171.canaca.com ([67.55.55.225]:38394 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab1KHUcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 15:32:04 -0500
X-Greylist: delayed 2067 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Nov 2011 15:32:04 EST
Message-ID: <ecb0ae9ca884c385bc6b0358b38e5605.squirrel@host171.canaca.com>
In-Reply-To: <1320779660.8062.141.camel@localhost.localdomain>
References: <1320779660.8062.141.camel@localhost.localdomain>
Date: Tue, 8 Nov 2011 14:57:28 -0500
Subject: Re: [PATCH] HID: hid-lg4ff: Casting (void *) value returned by
 kmalloc is useless
From: simon@mungewell.org
To: "Thomas Meyer" <thomas@m3y3r.de>
Cc: "Jiri Kosina" <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No objection from me if this is the proper way to do things.
Simon.

> From: Thomas Meyer <thomas@m3y3r.de>
>
>  Casting (void *) value returned by kmalloc is useless
>  as mentioned in Documentation/CodingStyle, Chap 14.
>
>  The semantic patch that makes this change is available
>  in scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci.
>
>  More information about semantic patching is available at
>  http://coccinelle.lip6.fr/
>
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
>
> diff -u -p a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
> --- a/drivers/hid/hid-lg4ff.c 2011-11-07 19:37:44.816570939 +0100
> +++ b/drivers/hid/hid-lg4ff.c 2011-11-08 09:03:29.394045138 +0100
> @@ -430,7 +430,7 @@ int lg4ff_init(struct hid_device *hid)
>  	}
>
>  	/* Add the device to device_list */
> -	entry = (struct lg4ff_device_entry *)kzalloc(sizeof(struct
> lg4ff_device_entry), GFP_KERNEL);
> +	entry = kzalloc(sizeof(struct lg4ff_device_entry), GFP_KERNEL);
>  	if (!entry) {
>  		hid_err(hid, "Cannot add device, insufficient memory.\n");
>  		return -ENOMEM;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


