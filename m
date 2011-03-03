Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab1CCUrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:47:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758472Ab1CCUrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:47:39 -0500
Message-ID: <4D6FFE5D.1030401@redhat.com>
Date: Thu, 03 Mar 2011 15:47:25 -0500
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: Avi Kivity <avi@redhat.com>, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@redhat.com>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
 boot
References: <20110225104823.GD29840@pcnci.linuxbox.cz> <4D67C077.6060108@redhat.com> <20110227172052.GB2474@nik-comp.lan> <4D6BA85B.7080908@redhat.com> <20110228143247.GE29840@pcnci.linuxbox.cz> <4D6BBC84.6020408@redhat.com> <20110228152823.GF29840@pcnci.linuxbox.cz> <4D6BC5CA.8060004@redhat.com> <20110228171550.GA2173@nik-comp.lan> <4D6EF536.305@redhat.com> <20110303070652.GG29840@pcnci.linuxbox.cz>
In-Reply-To: <20110303070652.GG29840@pcnci.linuxbox.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 02:06 AM, Nikola Ciprich wrote:
>> No worries.  What mess?
>>      
> twice sending the same mail, nevermind :)
>
>    
>> I have two things you can try:
>>
>> first is running a single VCPU guest, if you have not done so already.
>>      
> yup, UP guest is fine, just SMP doesn't work.
>
>    
>> Second is adding the bootparameter "clocksource=acpi_pm" to your guest
>> kernel.
>>      
> yes, this makes SMP work too! I just realized when You were asking about current
> clocksource, I told You only host source, not the guest. So I checked now,
> and (at least for UP, I guess for SMP it's the same), the clocksource is
> kvm-clock! So seems like it got broken with the TSC changes?
>    

What is the exact kernel version you are using in the guest.

It appears that some earlier 32-bit versions of kvm-clock enabled 
kernels are still missing the required atomic check for backwards-time 
protection which would be needed on SMP.  This explains why 64-bit is 
fine, 32-bit is not.

Why this change triggers that problem still is a slight mystery, 
logically it should only affect the system if you have an unstable TSC.

Zach
