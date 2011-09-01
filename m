Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab1IATYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 15:24:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50719 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab1IATYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 15:24:18 -0400
Message-ID: <4E5FDBDC.2030302@codemonkey.ws>
Date: Thu, 01 Sep 2011 14:24:12 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Eric B Munson <emunson@mgebm.net>, avi@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, arnd@arndb.de, riel@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, kvm-ppc@vger.kernel.org,
        aliguori@us.ibm.com, raharper@us.ibm.com, kvm-ia64@vger.kernel.org,
        Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH 0/4] Avoid soft lockup message when KVM is stopped by
 host
References: <1314660435-23293-1-git-send-email-emunson@mgebm.net> <20110830122630.GA19450@amt.cnet>
In-Reply-To: <20110830122630.GA19450@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2011 07:26 AM, Marcelo Tosatti wrote:
> On Mon, Aug 29, 2011 at 05:27:11PM -0600, Eric B Munson wrote:
>> Currently, when qemu stops a guest kernel that guest will issue a soft lockup
>> message when it resumes.  This set provides the ability for qemu to comminucate
>> to the guest that it has been stopped.  When the guest hits the watchdog on
>> resume it will check if it was suspended before issuing the warning.
>>
>> Eric B Munson (4):
>>    Add flag to indicate that a vm was stopped by the host
>>    Add functions to check if the host has stopped the vm
>>    Add generic stubs for kvm stop check functions
>>    Add check for suspended vm in softlockup detector
>>
>>   arch/x86/include/asm/pvclock-abi.h |    1 +
>>   arch/x86/include/asm/pvclock.h     |    2 ++
>>   arch/x86/kernel/kvmclock.c         |   14 ++++++++++++++
>>   include/asm-generic/pvclock.h      |   14 ++++++++++++++
>>   kernel/watchdog.c                  |   12 ++++++++++++
>>   5 files changed, 43 insertions(+), 0 deletions(-)
>>   create mode 100644 include/asm-generic/pvclock.h
>>
>> --
>> 1.7.4.1
>
> How is the host supposed to set this flag?
>
> As mentioned previously, if you save save/restore the offset added to
> kvmclock on stop/cont (and the TSC MSR, forgot to mention that), no
> paravirt infrastructure is required. Which means the issue is also fixed
> for older guests.

IIRC, the steal time patches have some logic that basically say:

if there was steal time:
    kick soft lockup detector

I wonder if that serves this purpose provided that time spent in stop is 
accounted as steal time.  If it isn't, perhaps it should be?

Regards,

Anthony Liguori

> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

