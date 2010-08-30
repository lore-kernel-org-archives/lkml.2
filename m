Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0H3JKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 05:10:40 -0400
Received: from david.siemens.de ([192.35.17.14]:24636 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab0H3JKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 05:10:39 -0400
Message-ID: <4C7B7572.3070406@siemens.com>
Date: Mon, 30 Aug 2010 11:10:10 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [KVM timekeeping 13/35] Perform hardware_enable in CPU_STARTING
 callback
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-14-git-send-email-zamsden@redhat.com> <4C77E89E.3040106@siemens.com> <4C784DB8.5090105@redhat.com>
In-Reply-To: <4C784DB8.5090105@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> On 08/27/2010 06:32 AM, Jan Kiszka wrote:
>> Zachary Amsden wrote:
>>    
>>> The CPU_STARTING callback was added upstream with the intention
>>> of being used for KVM, specifically for the hardware enablement
>>> that must be done before we can run in hardware virt.  It had
>>> bugs on the x86_64 architecture at the time, where it was called
>>> after CPU_ONLINE.  The arches have since merged and the bug is
>>> gone.
>>>      
>> What bugs are you referring to, or since which kernel version is
>> CPU_STARTING usable for KVM? I need to encode this into kvm-kmod.
>>    
> 
> Prior to the x86_64 / i386 merge, CPU_STARTING didn't work the same way 
> / exist in the x86_64 code... most of this is historical guesswork.  At 
> some point, the 32/64 versions of the code in smpboot.c got merged and 
> now it does.
> 
> Binary searching around my tree shows this timeframe:
> 
> 2.6.11? - 2.6.23 : silver age ; i386 and x86_64 merge underway
>     |
> 2.6.24 : bronze age ; i386 and x86_64 deprecated
>     |
> 2.6.26 : iron age; smpboot_32.c / smpboot_64.c merge
>       \
>       2.6.28 : CPU_STARTING exists and first used
> 
> /me scratches head wondering how this affects operation on older kernels....

I basically need to revert your patch on host kernels without
CPU_STARTING and also on those where it might be broken. So I will set
the barrier to 2.6.28 then.

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
