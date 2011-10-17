Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1JQPLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:11:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756111Ab1JQPLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:11:52 -0400
Date: Mon, 17 Oct 2011 17:11:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Terry Lambert <tlambert@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Driver for Primax keyboards violating USB HID spec
In-Reply-To: <1318637934-30006-1-git-send-email-tlambert@chromium.org>
Message-ID: <alpine.LNX.2.00.1110171710570.3541@pobox.suse.cz>
References: <1318637934-30006-1-git-send-email-tlambert@chromium.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Terry Lambert wrote:

> Primax keyboards with the issue this driver addresses report modifier
> keys as in band key events instead of as out of band modifier bits,
> resulting in the modifier keys generating key up events immediately
> before the keys they are intended to modify.  This driver rewrites
> the raw report data from such keyboards into USB HID 1.11 compliant
> report data.  It only matches the USB vendor and product IDs for the
> keyboard it has been tested on. Since there are several keyboards,
> notably a number of laptops and folding USB keyboards known to have
> similar unresolved problem reports, the list is expected to grow.
> 
> Signed-off-by: Terry Lambert <tlambert@chromium.org>
> ---
>  drivers/hid/Kconfig      |    8 +++
>  drivers/hid/Makefile     |    1 +
>  drivers/hid/hid-core.c   |    1 +
>  drivers/hid/hid-ids.h    |    3 +
>  drivers/hid/hid-primax.c |  117 ++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 130 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hid/hid-primax.c
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 1130a89..a097e17 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -441,6 +441,14 @@ config HID_PICOLCD_LEDS
>  	---help---
>  	  Provide access to PicoLCD's GPO pins via leds class.
>  
> +config HID_PRIMAX
> +	tristate "Primax non-fully HID-compliant devices" if EXPERT
> +	depends on USB_HID
> +	default !EXPERT

I have removed thi 'EXPERT' dependency (please see changelog of commit 
73d5e8f77e8 for rationale behind that) and applied. Thanks,

-- 
Jiri Kosina
SUSE Labs
