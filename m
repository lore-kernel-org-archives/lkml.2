Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab0H0XoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 19:44:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab0H0XoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 19:44:07 -0400
Message-ID: <4C784DB8.5090105@redhat.com>
Date: Fri, 27 Aug 2010 13:43:52 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 13/35] Perform hardware_enable in CPU_STARTING
 callback
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-14-git-send-email-zamsden@redhat.com> <4C77E89E.3040106@siemens.com>
In-Reply-To: <4C77E89E.3040106@siemens.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2010 06:32 AM, Jan Kiszka wrote:
> Zachary Amsden wrote:
>    
>> The CPU_STARTING callback was added upstream with the intention
>> of being used for KVM, specifically for the hardware enablement
>> that must be done before we can run in hardware virt.  It had
>> bugs on the x86_64 architecture at the time, where it was called
>> after CPU_ONLINE.  The arches have since merged and the bug is
>> gone.
>>      
> What bugs are you referring to, or since which kernel version is
> CPU_STARTING usable for KVM? I need to encode this into kvm-kmod.
>    

Prior to the x86_64 / i386 merge, CPU_STARTING didn't work the same way 
/ exist in the x86_64 code... most of this is historical guesswork.  At 
some point, the 32/64 versions of the code in smpboot.c got merged and 
now it does.

Binary searching around my tree shows this timeframe:

2.6.11? - 2.6.23 : silver age ; i386 and x86_64 merge underway
    |
2.6.24 : bronze age ; i386 and x86_64 deprecated
    |
2.6.26 : iron age; smpboot_32.c / smpboot_64.c merge
      \
      2.6.28 : CPU_STARTING exists and first used

/me scratches head wondering how this affects operation on older kernels....
