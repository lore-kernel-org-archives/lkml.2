Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab2HPITU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:19:20 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:42387 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756116Ab2HPITR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:19:17 -0400
Message-ID: <502CACFF.3000105@metafoo.de>
Date: Thu, 16 Aug 2012 10:19:11 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Jonathan Cameron <jic23@kernel.org>, "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 1/3] iio: add iio_read_channel_offset() consumer api
References: <A874F61F95741C4A9BA573A70FE3998F41EEFD6E@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EEFD6E@DQHE02.ent.ti.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 09:39 AM, Kim, Milo wrote:
> This allows the iio consumer to get the offset of the channel.
> The value of offset can be used when calculating the result such
> as 'result = raw * scale + offset'.

result = (raw + offset) * scale

Otherwise it looks good, except for:

> +/**
> + * iio_read_channel_offset() - read offset from a given channel
> + * @channel:		The channel being queried.
> + * @val:		Offset Value read back.
> + *
> + * Note offset can be used in the consumer when calculating the result
> + * such as 'result = raw * scale + offset'.
> + */

The documentation should go in the c file.

> +int iio_read_channel_offset(struct iio_channel *chan, int *val);
>  #endif

