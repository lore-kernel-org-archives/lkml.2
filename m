Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab2BVRhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:37:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51569 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab2BVRhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:37:53 -0500
Message-ID: <4F4527D3.9040906@zytor.com>
Date: Wed, 22 Feb 2012 09:37:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Nick Bowler <nbowler@elliptictech.com>
CC: Matt Fleming <matt@console-pimps.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH] x86, efi: Fix unaligned access and endian issues
References: <1329919208-8700-1-git-send-email-matt@console-pimps.org> <20120222164402.GA13354@elliptictech.com>
In-Reply-To: <20120222164402.GA13354@elliptictech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 08:44 AM, Nick Bowler wrote:
> On 2012-02-22 14:00 +0000, Matt Fleming wrote:
>> From: Matt Fleming<matt.fleming@intel.com>
>>
>> We need to read from and write to 'buf' a byte at a time otherwise
>> it's possible we'll perform an unaligned access, which can lead to a
>> segfault when cross-building an x86 kernel on risc architectures.
>>
>> Also, we may need to convert the endianness of the data we read
>> from/write to buf, so let's add some helper functions to do that.
> [...]
>> +static inline u32 read32_le(u8 *src)
>> +{
>> +	u32 data;
>> +
>> +	data = *src++;
>> +	data |= *src++<<  8;
>> +	data |= *src++<<  16;
>> +	data |= *src++<<  24;
>> +
>> +	return data;
>> +}
>
> We already have get_unaligned_le32 in<asm/unaligned.h>  for this.
>
>> +
>> +static inline void write32_le(u8 *dst, u32 data)
>> +{
>> +	*dst++ = data;
>> +	*dst++ = data>>  8;
>> +	*dst++ = data>>  16;
>> +	*dst++ = data>>  24;
>> +}
>
> Similarly, put_unaligned_le32.
>

This is user space; those headers are not exported.  However, sticking 
to the same name would be good.

I'm wondering if this is the kind of things that should be put in 
usr/include?

	-hpa


