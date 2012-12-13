Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab2LMEXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 23:23:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58304 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab2LMEXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 23:23:19 -0500
Message-ID: <50C95832.5030306@zytor.com>
Date: Wed, 12 Dec 2012 20:23:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kexec and struct boot_params
References: <50BFFB6E.5080108@zytor.com> <CAE9FiQU9mZpqhwX_a4Sv0a0aiReTxJfyJqNRVXTTXvjkFLrVZA@mail.gmail.com> <CAE9FiQXofExFJtPZZqynDGDZV6Kk2zpUwPcME9rB7L-AX5RLog@mail.gmail.com> <CAE9FiQX5XB-RMN-2AyCPix2EHVh8_WCO+fbJAFoJb8S0MUV_Sw@mail.gmail.com>
In-Reply-To: <CAE9FiQX5XB-RMN-2AyCPix2EHVh8_WCO+fbJAFoJb8S0MUV_Sw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 06:49 PM, Yinghai Lu wrote:
>>
>> Hi, Peter,
>>
>> What's your decision about this?
>>
>> Do you mean have one boot_params mask in initdata and AND that with
>> boot_params from bootloader
>> to clean not used bytes?
>>
>> So later will not need to check
>>      if (boot_params.hdr.xloadflags & USE_EXT_BOOT_PARAMS)
>> ?
>>
>> I worked out other patches that remove kdump 896M limitation.
>> would like to post those patches to get more testing.
>> those are needed for bigger system with lots of pcie devices.
>
>
> ping!
>

I still want to do what I mentioned before, because we need to not rely 
on the initialized/16-bit portion so much:

1. add a field in the uninitialized portion, call it "sentinel";
2. make sure the byte position corresponding to the "sentinel" field is
    nonzero in the bzImage file;
3. if the kernel boots up and sentinel is nonzero, erase those fields
    that you identified as uninitialized;
4. assign a proper boot loader ID to kexec, so we have a way of dealing
    with this kind of debacles in the future (that is what the
    bootloader ID is for: it gives us a way to work around
    bootloader-specific problems.)

We also need to formalize the 64-bit entry point properly, including all 
the entry conditions and so forth.  That needs to be documented.

Eric, any thoughts or additional opinions?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

