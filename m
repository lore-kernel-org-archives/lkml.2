Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab0ELUVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 16:21:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27762 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab0ELUVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 16:21:42 -0400
Message-ID: <4BEB0D5F.8070806@oracle.com>
Date: Wed, 12 May 2010 13:19:43 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] x86 efi: Fill all reserved memmap entries if add_efi_memmap
 specified.
References: <4BEAEF10.9040809@sgi.com> <4BEAF9B6.2040606@zytor.com>
In-Reply-To: <4BEAF9B6.2040606@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BEB0DC6.01C3:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2010 11:55 AM, H. Peter Anvin wrote:
> On 05/12/2010 11:10 AM, Mike Travis wrote:
>>
>> Currently, the e820_reserve_resources() function does not add entries
>> obtained via the "add_efi_memmap" kernel cmdline option.  This causes
>> /sys/firmware/memmap/... to be incomplete (stops after 128 entries).
>> Utilities that examine these entries then do not get the complete
>> picture of system memory.
>>
>> This patch causes the above function to use the e820 memmap instead
>> of the e820_saved memmap if "add_efi_memmap" cmdline option is
>> specified.
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> If I'm not mistaken, the very reason for the e820 vs e820_saved map is
> that the latter is supposed to reflect the firmware report, whereas the
> former is subject to be modified by the kernel.  As this is actually a
> reflection of the firmware (although it would be better if you could fix
> the bootloader instead of adding hacks in the kernel...) it really
> should go into e820_saved as well as e820.  Displaying the adjusted e820
> map doesn't seem appropriate under any circumstances.

Yes, you are right.

We should not touch e820_saved and keep /sys/firmware/memmap to be consistent with it.

YH
