Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab1LGVHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:07:42 -0500
Received: from host171.canaca.com ([67.55.55.225]:36473 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725Ab1LGVHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:07:41 -0500
Message-ID: <b92a2d1d30910b75f3354926d9fa26f6.squirrel@host171.canaca.com>
In-Reply-To: <1323290039-28073-1-git-send-email-dh.herrmann@googlemail.com>
References: <4EDFD23D.4030703@xenotime.net>
    <1323290039-28073-1-git-send-email-dh.herrmann@googlemail.com>
Date: Wed, 7 Dec 2011 16:07:38 -0500
Subject: Re: [PATCH] HID: wiimote: Select INPUT_FF_MEMLESS
From: simon@mungewell.org
To: "David Herrmann" <dh.herrmann@googlemail.com>
Cc: linux-input@vger.kernel.org, rdunlap@xenotime.net,
        linux-next@vger.kernel.org, jkosina@suse.cz,
        linux-kernel@vger.kernel.org,
        "David Herrmann" <dh.herrmann@googlemail.com>
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


> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index edf2b2b..dae04a0 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -591,6 +591,7 @@ config HID_WIIMOTE
>  	depends on BT_HIDP
>  	depends on LEDS_CLASS
>  	select POWER_SUPPLY
> +	select INPUT_FF_MEMLESS
>  	---help---
>  	Support for the Nintendo Wii Remote bluetooth device.

I don't mean to be a complainer, but shouldn't the WiiMote module depend
on FF_MEMLESS rather than just forcing it on.

The module could also #define the appropriate bits so that FF_MEMLESS was
only used when available, the rumble motor is a very small part of the
WiiMote's feature set.

Some people might not want FF_MEMLESS enabled.
Simon.

