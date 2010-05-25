Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab0EYWqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:46:14 -0400
Received: from relay2.sgi.com ([192.48.179.30]:55402 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756413Ab0EYWqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:46:13 -0400
Message-ID: <4BFC5330.5080907@sgi.com>
Date: Tue, 25 May 2010 15:46:08 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai <yinghai.lu@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, jkosina@novell.com
Subject: Re: [Patch 1/1] x86 efi: Fill all reserved memmap entries if add_efi_memmap
 specified.
References: <4BEAEF10.9040809@sgi.com> <4BEAF9B6.2040606@zytor.com> <4BEB0D5F.8070806@oracle.com> <4BEB1781.1080907@sgi.com> <4BEC6C94.2020100@sgi.com> <4BEC73B2.2020909@oracle.com> <4BEC7544.1080506@sgi.com> <4BEC8161.6050206@zytor.com> <4BFC5080.6030103@sgi.com> <4BFC5217.6060804@zytor.com>
In-Reply-To: <4BFC5217.6060804@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



H. Peter Anvin wrote:
> On 05/25/2010 03:34 PM, Mike Travis wrote:
>>
>> H. Peter Anvin wrote:
>>> On 05/13/2010 02:55 PM, Mike Travis wrote:
>>>> I saw that too, and wondered why e820_saved did not
>>>> have the extra entries.   The comment indicates it
>>>> should.
>>>>
>>>> I'm on the system tonight and will investigate this
>>>> further.
>>>>
>>> e820_saved lacks the extra entries because they aren't being passed in
>>> from the bootloader, as they should, and instead you're using
>>> add_efi_memmap which is, as far as the kernel is concerned, a post-boot
>>> modification.
>>>
>>> That being said, add_efi_memmap does come from the firmware, and as such
>>> it would be legitimate for it to add them to e820_saved.
>>>
>>> 	-hpa
>> Did this last patch meet expectations?
>>
>> http://marc.info/?l=linux-kernel&m=127474230623061&w=4
>>
> 
> I'm concerned about calling sanitize_e820_map() on e820_saved; it is
> supposed to reflect the raw data as reported by the source, and
> sanitizing it would corrupt that.
> 
> 	-hpa

I wondered about that. Sanitize seems to remove adjacent
entries, etc. making the map smaller, but I couldn't detect
any real differences (though admittedly I didn't do a byte
by byte comparison.)

But I'll submit another with that call removed.

Thanks,
Mike
