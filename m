Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab1EYFVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 01:21:54 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4901 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab1EYFVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 01:21:52 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4DDC91E1.40104@broadcom.com>
Date: Wed, 25 May 2011 07:21:37 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "George Spelvin" <linux@horizon.com>
cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "error27@gmail.com" <error27@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
 algorithm
References: <20110524225224.32163.qmail@science.horizon.com>
In-Reply-To: <20110524225224.32163.qmail@science.horizon.com>
X-WSS-ID: 61C24D463IC5272593-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2011 12:52 AM, George Spelvin wrote:
>> V3:
>> - added function crc8_create().
>> - crc8_create() takes polynomial and bit direction as parameters.
> May I suggest that crc8_create is A Stupid Idea.  Since the bit order
> (and polynomial) will always be compile-time constants, just let the
> call sites call crc8_create_[lm]sb_first() directly.

Thanks for be subtle in your suggestion. The crc8 module can have 
multiple callers, which have their own bit order and polynomial. From 
caller perspective they are likely compile-time constants. You are right 
that the extra layer crc8_create is not adding much and callers should 
the bit order specific create functions directly.
> That way there's no need for the enum, and specifying something
> other than lsb_first and msb_first is a compile-time error rather than
> a run-time one

If callers use the specific function they can not specify a bit order so 
no compile-time error.

> It might be nice to add some const declarations, and use size_t
> for the buffer length:
> u8 crc8(u8 const *table, u8 const *pdata, size_t nbytes, u8 crc)
> or
> u8 crc8(u8 const table[256], u8 const *pdata, size_t nbytes, u8 crc)
>
>
> Style points you might consider, but I do not consider essential:
>
> Personally, when a function parameter is a pointer to
> a fixed-size array, I prefer to declare it as
> 	void crc8_create_lsb_first(u8 table[256], u8 poly)
> for better documentation, but that's your choice.
>
> The CRC8_GOOD_VALUE could be explained if you like.  "If a CRC is inverted
> before transmission, the CRC computed over the while (message+crc)
> is _table[x], when x is the bit pattern of the modification (almost
> always 0xff)."

Great remarks. Will update the code.

> Thanks!

Thanks.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


