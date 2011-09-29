Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab1I2S1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:27:54 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:53806 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582Ab1I2S1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:27:52 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4] fat: don't use custom hex_to_bin()
References: <87ipob8l4l.fsf@devron.myhome.or.jp>
	<f176b6be3c0de274839e813d6ac514d6f7736e77.1317308975.git.andriy.shevchenko@linux.intel.com>
	<1317310634.1854.25.camel@Joe-Laptop>
Date: Fri, 30 Sep 2011 03:27:48 +0900
In-Reply-To: <1317310634.1854.25.camel@Joe-Laptop> (Joe Perches's message of
	"Thu, 29 Sep 2011 08:37:14 -0700")
Message-ID: <8762kb8aqj.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

>> +
>> +					if (hex2bin(uc, ip + 1, 2) < 0)
>>  						return -EINVAL;
>> -					}
>> -					*op++ = ec & 0xFF;
>> -					*op++ = ec >> 8;
>> +
>> +					*(wchar_t *)op++ = uc[0] << 8 | uc[1];
>
> perhaps:
>
> 	__le16	foo;
>
> 	if (hex2bin((u8 *)&foo, ip + 1, 2) < 0)
> 		return -EINVAL;
> 	*(u16 *)op = le16_to_cpu(foo);
>
> 	op += 2;

I also thought about it. But I think it is not so good, like you had
mistake.  It should actually be "__be16 foo" and "be16_to_cpu()".

If we used sscanf() instead of hex2bin(), I might agree to use
"le16_to_cpu()" though.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
