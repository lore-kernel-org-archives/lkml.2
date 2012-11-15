Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab2KOXf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 18:35:29 -0500
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:41430
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130Ab2KOXf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 18:35:27 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I936eI1432Izz1de0h1202h1d1ah1d2ahzz8275bhz2dh668h839hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
X-WSS-ID: 0MDJYUV-01-A89-02
X-M-MSG: 
Message-ID: <50A57C35.10906@amd.com>
Date: Thu, 15 Nov 2012 18:35:17 -0500
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Gene Heskett <gheskett@wdtv.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, <hpa@zytor.com>,
        <mingo@elte.hu>, <tglx@linutronix.de>,
        <herrmann.der.user@googlemail.com>, <bp@alien8.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, microcode, AMD: Add support for family 16h processors
References: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com> <20121115204503.GB18032@khazad-dum.debian.net> <201211151801.23160.gheskett@wdtv.com>
In-Reply-To: <201211151801.23160.gheskett@wdtv.com>
Content-Type: text/plain; charset="windows-1256"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/15/2012 06:01 PM, Gene Heskett wrote:
> On Thursday 15 November 2012, Henrique de Moraes Holschuh wrote:
>> On Thu, 15 Nov 2012, Boris Ostrovsky wrote:
>>> Add valid patch size for family 16h processors
>>>
>>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
>>
>> Is this something that needs to go to -stable ?
>
> IMO, and if I had an oar in this water, yes.  Its been missing since the
> Intel folks started playing with it a couple years back up the log.  I
> have the amd_ucode files in my /lib/firmware tree,
>
> root@coyote:/opt/os9# ls -l /lib/firmware/amd-ucode/
> total 76
> -rw-r--r-- 1 root root   642 2012-01-17 11:50 INSTALL
> -rw-r--r-- 1 root root  9987 2012-01-17 11:50 LICENSE
> -rw-r--r-- 1 root root 12404 2012-01-17 11:50 microcode_amd.bin
> -rw-r--r-- 1 root root  1526 2012-01-17 11:50 microcode_amd.bin.README
> -rw-r--r-- 1 root root  2644 2012-01-17 11:50 microcode_amd_fam15h.bin
> -rw-r--r-- 1 root root   510 2012-01-17 11:50
> microcode_amd_fam15h.bin.README
> -rw-r--r-- 1 root root  2012 2009-01-20 04:48 microcode_amd.phenom-V83
> -rw-r--r-- 1 root root 15020 2012-01-17 11:50 microcode_amd_solaris.bin
> -rw-r--r-- 1 root root  1685 2012-01-17 11:50
> microcode_amd_solaris.bin.README
> -rw-r--r-- 1 root root  6227 2012-01-17 11:50 README
>
> but I can't recall the last time I saw the code sign in during dmesg.
> Old, slow 4 core phenom here.  AMD was forgotten about when the loading
> of it was moved from the kernel options to /etc/init.d/microcode.  For
> an AMD user, that was not a show stopper, but it wasn't a Good Thing(TM)
> either.

One possibility is that BIOS already incorporated all patches (which 
typically is the case) and so the driver doesn't have to do anything.

-boris


>
>>
>>>   #define F1XH_MPB_MAX_SIZE 2048
>>>   #define F14H_MPB_MAX_SIZE 1824
>>>   #define F15H_MPB_MAX_SIZE 4096
>>>
>>> +#define F16H_MPB_MAX_SIZE 3458
>>>
>>>   	switch (c->x86) {
>>>
>>>   	case 0x14:
>>> @@ -198,6 +199,9 @@ static unsigned int verify_patch_size(int cpu, u32
>>> patch_size,
>>>
>>>   	case 0x15:
>>>   		max_size = F15H_MPB_MAX_SIZE;
>>>   		break;
>>>
>>> +	case 0x16:
>>> +		max_size = F16H_MPB_MAX_SIZE;
>>> +		break;
>>>
>>>   	default:
>>>   		max_size = F1XH_MPB_MAX_SIZE;
>>>   		break;
>>
>> Because it looks like without this patch, some valid microcode updates
>> would be rejected by the kernel...
>
>
> Cheers, Gene
>

