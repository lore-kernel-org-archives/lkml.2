Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1LCJUR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 04:20:17 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32945 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab1LCJUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 04:20:15 -0500
References: <1322600880.1534.325.camel@localhost.localdomain>
In-Reply-To: <1322600880.1534.325.camel@localhost.localdomain>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <B3E3F396-DAA8-47B5-BCCB-4CC79766B11C@gmail.com>
Cc: "IvDoorn@gmail.com" <IvDoorn@gmail.com>,
        "helmut.schaa@googlemail.com" <helmut.schaa@googlemail.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPad Mail (9A405)
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Use kcalloc instead of kzalloc to allocate array
Date: Sat, 3 Dec 2011 10:20:10 +0100
To: Thomas Meyer <thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 nov. 2011, at 22:08, Thomas Meyer <thomas@m3y3r.de> wrote:

> The advantage of kcalloc is, that will prevent integer overflows which could
> result from the multiplication of number of elements and size and it is also
> a bit nicer to read.
> 
> The semantic patch that makes this change is available
> in https://lkml.org/lkml/2011/11/25/107
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> 
> diff -u -p a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c 2011-11-28 19:36:47.770108588 +0100
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c 2011-11-28 19:54:53.495525543 +0100
> @@ -831,11 +831,11 @@ static int rt2x00lib_probe_hw_modes(stru
>    if (spec->supported_rates & SUPPORT_RATE_OFDM)
>        num_rates += 8;
> 
> -    channels = kzalloc(sizeof(*channels) * spec->num_channels, GFP_KERNEL);
> +    channels = kcalloc(spec->num_channels, sizeof(*channels), GFP_KERNEL);
>    if (!channels)
>        return -ENOMEM;
> 
> -    rates = kzalloc(sizeof(*rates) * num_rates, GFP_KERNEL);
> +    rates = kcalloc(num_rates, sizeof(*rates), GFP_KERNEL);
>    if (!rates)
>        goto exit_free_channels;
> 
