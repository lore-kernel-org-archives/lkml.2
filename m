Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab2LQPun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:50:43 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35686 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752179Ab2LQPum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:50:42 -0500
Message-ID: <1355759442.13361.21.camel@joe-AO722>
Subject: Re: PATCH] backlight: add lms501kf03 LCD driver
From: Joe Perches <joe@perches.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Date: Mon, 17 Dec 2012 07:50:42 -0800
In-Reply-To: <000001cddc2f$a2b2e8a0$e818b9e0$%han@samsung.com>
References: <000001cddc2f$a2b2e8a0$e818b9e0$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-17 at 17:22 +0900, Jingoo Han wrote:
> Add the lms501kf03 LCD panel driver. The lms501kf03 LCD panel (800
> x 480) driver uses 3-wired SPI inteface.

A trivial note:

> diff --git a/drivers/video/backlight/lms501kf03.c b/drivers/video/backlight/lms501kf03.c

[]

> +static const unsigned short seq_rgb_gamma[] = {
> +	0xc1, 0x01, 0x03, 0x07, 0x0f, 0x1a, 0x22, 0x2c, 0x33, 0x3c,
> +	0x46, 0x4f, 0x58, 0x60, 0x69, 0x71, 0x79, 0x82, 0x89, 0x92,
> +	0x9a, 0xa1, 0xa9, 0xb1, 0xb9, 0xc1, 0xc9, 0xcf, 0xd6, 0xde,
> +	0xe5, 0xec, 0xf3, 0xf9, 0xff, 0xdd, 0x39, 0x07, 0x1c, 0xcb,
> +	0xab, 0x5f, 0x49, 0x80, 0x03, 0x07, 0x0f, 0x19, 0x20, 0x2a,
> +	0x31, 0x39, 0x42, 0x4b, 0x53, 0x5b, 0x63, 0x6b, 0x73, 0x7b,
> +	0x83, 0x8a, 0x92, 0x9b, 0xa2, 0xaa, 0xb2, 0xba, 0xc2, 0xca,
> +	0xd0, 0xd8, 0xe1, 0xe8, 0xf0, 0xf8, 0xff, 0xf7, 0xd8, 0xbe,
> +	0xa7, 0x39, 0x40, 0x85, 0x8c, 0xc0, 0x04, 0x07, 0x0c, 0x17,
> +	0x1c, 0x23, 0x2b, 0x34, 0x3b, 0x43, 0x4c, 0x54, 0x5b, 0x63,
> +	0x6a, 0x73, 0x7a, 0x82, 0x8a, 0x91, 0x98, 0xa1, 0xa8, 0xb0,
> +	0xb7, 0xc1, 0xc9, 0xcf, 0xd9, 0xe3, 0xea, 0xf4, 0xff, 0x00,
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +	ENDDEF
> +};

All of these ushort arrays could be uchar.

> +static int lms501kf03_spi_write(struct lms501kf03 *lcd, unsigned char address,
> +				unsigned char command)
> +{
> +	int ret;
> +
> +	ret = lms501kf03_spi_write_byte(lcd, address, command);
> +
> +	return ret;
> +}
> +
> +static int lms501kf03_panel_send_sequence(struct lms501kf03 *lcd,
> +					const unsigned short *wbuf)
> +{
> +	int ret = 0, i = 0;
> +
> +	while (wbuf[i] != ENDDEF) {

Using an unsigned short where the high order byte
is an end-of-buffer indicator is a bit space wasteful.

Perhaps a sized struct or array instead.

