Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab2CFIoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 03:44:25 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:30149 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758301Ab2CFIoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 03:44:08 -0500
Message-ID: <4F55CE54.4000300@bfs.de>
Date: Tue, 06 Mar 2012 09:44:04 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] x86, efi: fix pointer math issue in handle_ramdisks()
References: <20120305180614.GA26880@elgon.mountain> <4F550917.9020508@bfs.de> <4F551504.5010401@zytor.com>
In-Reply-To: <4F551504.5010401@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 05.03.2012 20:33, schrieb H. Peter Anvin:
> On 03/05/2012 10:42 AM, walter harms wrote:
>>
>>
>> Am 05.03.2012 19:06, schrieb Dan Carpenter:
>>> "filename" is a efi_char16_t string so this check for reaching the end
>>> of the array doesn't work.  We need to cast the pointer to (u8 *) before
>>> doing the math.
>>>
>>> This patch changes the "filename" to "filename_16" to avoid confusion in
>>> the future.
>>>
>>
>> maybe it is a bit late,  but ...
>> is efi_char16_t a generic requirement for EFI ? perhaps we can use wchar_t
>> since it is intended for such cases. additional we would get an api for free.
>>
> 
> wchar_t is typically 32 bits on Linux.  16-bit anything is a major fail
> since Unicode doesn't actually fit in 16 bits.
> 
hi,

yep, but i was asking about efi. The basic idea is of cause to map efi_char16_t -> wchar_t
and back and make this a prototype for every driver that needs a special charset.
That would make it possible to recycle the wcs* interface of libc.
IMHO it seems more reasonable than adding one for each (upcoming) type.

re,
 wh
