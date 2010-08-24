Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab0HXAvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 20:51:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab0HXAv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 20:51:29 -0400
Message-ID: <4C73177E.3050805@redhat.com>
Date: Mon, 23 Aug 2010 14:51:10 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 03/35] Move TSC offset writes to common code
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-4-git-send-email-zamsden@redhat.com> <20100820170643.GB2937@mothafucka.localdomain>
In-Reply-To: <20100820170643.GB2937@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 07:06 AM, Glauber Costa wrote:
> On Thu, Aug 19, 2010 at 10:07:17PM -1000, Zachary Amsden wrote:
>    
>> Also, ensure that the storing of the offset and the reading of the TSC
>> are never preempted by taking a spinlock.  While the lock is overkill
>> now, it is useful later in this patch series.
>>
>> +	spinlock_t tsc_write_lock;
>>      
> Forgive my utter ignorance, specially if it is to become
> obvious in a latter patch: This is a vcpu-local operation,
> uses rdtscl, so pcpu-local too, and we don't expect
> multiple writers to it at the same time.
>
> Why do we need this lock?
>
>    

Synchronizing access to the variables which we use to match TSC writes 
across multiple VCPUs.

