Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab0HXAww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 20:52:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab0HXAwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 20:52:49 -0400
Message-ID: <4C7317D9.5080002@redhat.com>
Date: Mon, 23 Aug 2010 14:52:41 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 05/35] Move TSC reset out of vmcb_init
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-6-git-send-email-zamsden@redhat.com> <20100820170849.GC2937@mothafucka.localdomain>
In-Reply-To: <20100820170849.GC2937@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 07:08 AM, Glauber Costa wrote:
> On Thu, Aug 19, 2010 at 10:07:19PM -1000, Zachary Amsden wrote:
>    
>> The VMCB is reset whenever we receive a startup IPI, so Linux is setting
>> TSC back to zero happens very late in the boot process and destabilizing
>> the TSC.  Instead, just set TSC to zero once at VCPU creation time.
>>
>> Why the separate patch?  So git-bisect is your friend.
>>
>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>>      
> Shouldn't we set for whatever value the BSP already has, and then the BSP to
> zero? Since vcpus are initialized at different times, this pretty much
> guarantees that the guest will have desynchronized tsc at all cases
> (not that if it was better before...)
>    

Yes, we should - but it takes a lot more machinery to do that, and so it 
happens later in the series.  You have to match the offsets for the BSP 
and other vcpus...
