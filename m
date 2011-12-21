Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1LUUPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:15:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37590 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab1LUUPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:15:16 -0500
Message-ID: <4EF23E41.40608@zytor.com>
Date: Wed, 21 Dec 2011 12:14:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Thomas Renninger <trenn@suse.de>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, kay.sievers@vrf.org, davej@redhat.com,
        kay.sievers@vrfy.org
Subject: Re: [PATCH 7/8] cpufreq: Add support for x86 cpuinfo auto loading
 v3
References: <1324338394-4670-1-git-send-email-andi@firstfloor.org> <1324338394-4670-8-git-send-email-andi@firstfloor.org> <201112211203.26153.trenn@suse.de> <20111221201227.GA9262@alboin.amr.corp.intel.com>
In-Reply-To: <20111221201227.GA9262@alboin.amr.corp.intel.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 12:12 PM, Andi Kleen wrote:
>>> +static const struct x86_cpu_id powernow_k8_ids[] = {
>>> +	{ X86_VENDOR_AMD, 0xf, },
>>> +	{ X86_VENDOR_AMD, 0x10, },
>>> +	{ X86_VENDOR_AMD, 0x11, },
>>> +	{ X86_VENDOR_AMD, 0x12, },
>>> +	{ X86_VENDOR_AMD, 0x13, },
>>> +	{ X86_VENDOR_AMD, 0x14, },
>> { X86_VENDOR_AMD, 0x15, },
>>
>> Should also have BullDozer family included.
> 
> I think it really needs a cpuid feature bit for the hwpstate.  This is
> not in one of the normal CPUID leaves, so the amd specific CPU init
> code would need to set it.
> 
> I added 0x15 for now, but it would be good if someone with the hardware
> fixed it like this.
> 
> Then could just add a match on "AMD-hw pstate" or so.
> 

Agreed.  This is literally screaming for a synthetic CPUID bit.

	-hpa

