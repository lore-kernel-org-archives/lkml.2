Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1AFUDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:03:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab1AFUDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:03:52 -0500
Message-ID: <4D262024.1030300@redhat.com>
Date: Thu, 06 Jan 2011 10:03:48 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM TSC trapping / migration 1/2] Add TSC trapping for SVM and
 VMX
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com> <1294308645-31113-2-git-send-email-zamsden@redhat.com> <4D25A842.8090102@redhat.com>
In-Reply-To: <4D25A842.8090102@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 01:32 AM, Avi Kivity wrote:
> On 01/06/2011 12:10 PM, Zachary Amsden wrote:
>> Reasons to trap the TSC are numerous, but we want to avoid it as much
>> as possible for performance reasons.
>>
>> We provide two conservative modes via modules parameters and userspace
>> hinting.  First, the module can be loaded with "tsc_auto=1" as a module
>> parameter, which turns on conservative TSC trapping only when it is
>> required (when unstable TSC or faster KHZ CPU is detected).
>>
>> For userspace hinting, we enable trapping only if necessary.  Userspace
>> can hint that a VM needs a fixed frequency TSC, and also that SMP
>> stability will be required.  In that case, we conservatively turn on
>> trapping when it is needed.  In addition, users may now specify the
>> desired TSC rate at which to run.  If this rate differs significantly
>> from the host rate, trapping will be enabled.
>>
>> There is also an override control to allow TSC trapping to be turned on
>> or off unconditionally for testing.
>>
>> We indicate to pvclock users that the TSC is being trapped, to allow
>> avoiding overhead and directly using RDTSCP (only for SVM).  This
>> optimization is not yet implemented.
>>
>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h    |    6 +-
>>   arch/x86/include/asm/pvclock-abi.h |    1 +
>>   arch/x86/kvm/svm.c                 |   20 ++++++
>>   arch/x86/kvm/vmx.c                 |   21 +++++++
>>   arch/x86/kvm/x86.c                 |  113 
>> +++++++++++++++++++++++++++++++++---
>>   arch/x86/kvm/x86.h                 |    2 +
>>   include/linux/kvm.h                |   15 +++++
>>   7 files changed, 168 insertions(+), 10 deletions(-)
>
>
> Haven't reviewed yet, but Documentation/kvm/api.txt is missing here.
>

That will be included when I port to upstream head.  When dealing with 
software documentation, too much is never enough.

Zach
