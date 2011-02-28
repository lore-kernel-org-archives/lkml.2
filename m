Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab1B1P5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:57:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab1B1P5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:57:03 -0500
Message-ID: <4D6BC5CA.8060004@redhat.com>
Date: Mon, 28 Feb 2011 10:56:58 -0500
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: Avi Kivity <avi@redhat.com>, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
 boot
References: <4D664E85.8070808@redhat.com> <20110224124151.GK25673@pcnci.linuxbox.cz> <4D665449.4050908@redhat.com> <20110224125702.GC29840@pcnci.linuxbox.cz> <20110225104823.GD29840@pcnci.linuxbox.cz> <4D67C077.6060108@redhat.com> <20110227172052.GB2474@nik-comp.lan> <4D6BA85B.7080908@redhat.com> <20110228143247.GE29840@pcnci.linuxbox.cz> <4D6BBC84.6020408@redhat.com> <20110228152823.GF29840@pcnci.linuxbox.cz>
In-Reply-To: <20110228152823.GF29840@pcnci.linuxbox.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> On Mon, Feb 28, 2011 at 10:17:24AM -0500, Zachary Amsden wrote:
>    
>> On 02/28/2011 09:32 AM, Nikola Ciprich wrote:
>>      
>>>> Does the bug you are hitting manifest on both Intel and AMD platforms?
>>>>
>>>>          
>>> I don't have any AMD box here, I'll try this out at my home box.
>>>
>>>
>>>        
>>>> Further, do the systems you are hitting this on have stable or unstable
>>>> TSCs?
>>>>
>>>>          
>>> how do I find this out? I don't see any warning about TSC in guest, but I've
>>> just started it..
>>> n.
>>>        
>> Before worrying about the guest, is the host TSC stable?  What is the
>> host clocksource?
>>      
> not sure, I'm not setting anything specifically, is this snippet of dmesg relevant:
>
> [    1.148829] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
> [    1.148934] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 40, 41, 42, 43, 44, 0
> [    1.149331] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    1.151831] hpet: hpet2 irq 40 for MSI
> [    1.151962] hpet: hpet3 irq 41 for MSI
> [    1.155930] hpet: hpet4 irq 42 for MSI
> [    1.159937] hpet: hpet5 irq 43 for MSI
> [    1.163943] hpet: hpet6 irq 44 for MSI
> [    1.175955] Switching to clocksource tsc
>
> so I guess I'm using hpet?
> n.
>
>
>    
Looks like you are using tsc based on the last line.  Can you tell us 
please

cat /proc/cpuinfo
cat /sys/devices/system/clocksource/clocksource0/current_clocksource

and grep -i dmesg for these keywords: TSC, clock, hpet, stable, khz, kvm
