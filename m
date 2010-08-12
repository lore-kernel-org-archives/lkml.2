Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab0HLGss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 02:48:48 -0400
Received: from smtp.nokia.com ([192.100.122.230]:52185 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab0HLGsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 02:48:45 -0400
Subject: Re: [PATCH (for some future time)] drivers/net: Convert unbounded
 kzalloc calls to kcalloc
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Joe Perches <joe@perches.com>
Cc: netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1281546168.3976.39.camel@Joe-Laptop.home>
References: <1281546168.3976.39.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 09:48:14 +0300
Message-ID: <1281595694.4440.2.camel@powerslave>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Aug 2010 06:48:19.0919 (UTC) FILETIME=[59A335F0:01CB39EA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-11 at 19:02 +0200, ext Joe Perches wrote:
> These changes may be slightly safer in some instances.
> 
> There are other kzalloc calls with a multiply, but those
> calls are typically "small fixed #" * sizeof(some pointer)"
> and those are not converted.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

[...]

>  drivers/net/wireless/wl12xx/wl1271_scan.c |    2 +-

[...]

> diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.c b/drivers/net/wireless/wl12xx/wl1271_scan.c
> index fec43ee..30dc100 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_scan.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_scan.c
> @@ -248,7 +248,7 @@ int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
> 
>         wl->scan.req = req;
> 
> -       wl->scan.scanned_ch = kzalloc(req->n_channels *
> +       wl->scan.scanned_ch = kcalloc(req->n_channels,
>                                       sizeof(*wl->scan.scanned_ch),
>                                       GFP_KERNEL);
>         wl1271_scan_stm(wl);

For the wl1271 part:

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>

-- 
Cheers,
Luca.

