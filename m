Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1I2Ov5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:51:57 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:47967 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1I2Ovz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:51:55 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] fat: don't use custom hex_to_bin()
References: <87bou5inkk.fsf@devron.myhome.or.jp>
	<2c8e77b881028c0a11f3cfef4ebb231c3236d60c.1317302092.git.andriy.shevchenko@linux.intel.com>
Date: Thu, 29 Sep 2011 23:51:53 +0900
In-Reply-To: <2c8e77b881028c0a11f3cfef4ebb231c3236d60c.1317302092.git.andriy.shevchenko@linux.intel.com>
	(Andy Shevchenko's message of "Thu, 29 Sep 2011 16:15:40 +0300")
Message-ID: <87ehyz8kqe.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:

> +					/* The ip contains 2 bytes in little
> +					 * endian format. We need to get them
> +					 * in native endian. */
> +
> +					rc = hex2bin(op++, ip + 3, 1);
> +					if (rc < 0)
> +						return -EINVAL;
> +
> +					rc = hex2bin(op++, ip + 1, 1);
> +					if (rc < 0)
>  						return -EINVAL;
> -					}
> -					*op++ = ec & 0xFF;
> -					*op++ = ec >> 8;
> +

It will not work for big endian arch correctly like original code.

"ip" is made like following,

			if (uni_xlate == 1) {
				*op++ = ':';
				op = pack_hex_byte(op, ec >> 8);
				op = pack_hex_byte(op, ec);
				len -= 5;
			} else {


Maybe, my explanation was not good. Like above, "ip" format is like
":1234" (can say big endian, it's the string though), so, this code made
a unicode char (op) as little endian.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
