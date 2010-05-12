Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab0ELVDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:03:04 -0400
Received: from relay2.sgi.com ([192.48.179.30]:51492 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751113Ab0ELVDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:03:00 -0400
Message-ID: <4BEB1781.1080907@sgi.com>
Date: Wed, 12 May 2010 14:02:57 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Yinghai <yinghai.lu@oracle.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] x86 efi: Fill all reserved memmap entries if add_efi_memmap
 specified.
References: <4BEAEF10.9040809@sgi.com> <4BEAF9B6.2040606@zytor.com> <4BEB0D5F.8070806@oracle.com>
In-Reply-To: <4BEB0D5F.8070806@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yinghai wrote:
> On 05/12/2010 11:55 AM, H. Peter Anvin wrote:
>> On 05/12/2010 11:10 AM, Mike Travis wrote:
>>> Currently, the e820_reserve_resources() function does not add entries
>>> obtained via the "add_efi_memmap" kernel cmdline option.  This causes
>>> /sys/firmware/memmap/... to be incomplete (stops after 128 entries).
>>> Utilities that examine these entries then do not get the complete
>>> picture of system memory.
>>>
>>> This patch causes the above function to use the e820 memmap instead
>>> of the e820_saved memmap if "add_efi_memmap" cmdline option is
>>> specified.
>>>
>>> Signed-off-by: Mike Travis <travis@sgi.com>
>>> Signed-off-by: Jack Steiner <steiner@sgi.com>
>> If I'm not mistaken, the very reason for the e820 vs e820_saved map is
>> that the latter is supposed to reflect the firmware report, whereas the
>> former is subject to be modified by the kernel.  As this is actually a
>> reflection of the firmware (although it would be better if you could fix
>> the bootloader instead of adding hacks in the kernel...) it really
>> should go into e820_saved as well as e820.  Displaying the adjusted e820
>> map doesn't seem appropriate under any circumstances.
> 
> Yes, you are right.
> 
> We should not touch e820_saved and keep /sys/firmware/memmap to be consistent with it.
> 
> YH


I'm confused.  Should I:

 - copy the extra memmap entries into e820_saved and fill early_memmap from that?
or
 - don't touch e820_saved and use e820 to fill early_memmap (which is how it is now).

Thanks,
Mike
