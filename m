Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab1LCLqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 06:46:18 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52461 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab1LCLqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 06:46:16 -0500
MIME-Version: 1.0
In-Reply-To: <1322600880.1534.325.camel@localhost.localdomain>
References: <1322600880.1534.325.camel@localhost.localdomain>
Date: Sat, 3 Dec 2011 12:46:15 +0100
Message-ID: <CAOZOX0UU7Jcd1XbV-bM4OBCwwySNyVOwQ_u2yhwyigfUgx=eBA@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Use kcalloc instead of kzalloc to allocate array
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: gwingerde@gmail.com, helmut.schaa@googlemail.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 10:08 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
> The advantage of kcalloc is, that will prevent integer overflows which could
> result from the multiplication of number of elements and size and it is also
> a bit nicer to read.
>
> The semantic patch that makes this change is available
> in https://lkml.org/lkml/2011/11/25/107
>
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>
> diff -u -p a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c 2011-11-28 19:36:47.770108588 +0100
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c 2011-11-28 19:54:53.495525543 +0100
> @@ -831,11 +831,11 @@ static int rt2x00lib_probe_hw_modes(stru
>        if (spec->supported_rates & SUPPORT_RATE_OFDM)
>                num_rates += 8;
>
> -       channels = kzalloc(sizeof(*channels) * spec->num_channels, GFP_KERNEL);
> +       channels = kcalloc(spec->num_channels, sizeof(*channels), GFP_KERNEL);
>        if (!channels)
>                return -ENOMEM;
>
> -       rates = kzalloc(sizeof(*rates) * num_rates, GFP_KERNEL);
> +       rates = kcalloc(num_rates, sizeof(*rates), GFP_KERNEL);
>        if (!rates)
>                goto exit_free_channels;
>
