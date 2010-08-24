Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab0HXA7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 20:59:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab0HXA66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 20:58:58 -0400
Message-ID: <4C731949.4010207@redhat.com>
Date: Mon, 23 Aug 2010 14:58:49 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 11/35] Add helper functions for time computation
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-12-git-send-email-zamsden@redhat.com> <20100820173440.GF2937@mothafucka.localdomain>
In-Reply-To: <20100820173440.GF2937@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 07:34 AM, Glauber Costa wrote:
> On Thu, Aug 19, 2010 at 10:07:25PM -1000, Zachary Amsden wrote:
>    
>> Add a helper function to compute the kernel time and convert nanoseconds
>> back to CPU specific cycles.  Note that these must not be called in preemptible
>> context, as that would mean the kernel could enter software suspend state,
>> which would cause non-atomic operation.
>>
>> Also, convert the KVM_SET_CLOCK / KVM_GET_CLOCK ioctls to use the kernel
>> time helper, these should be bootbased as well.
>>      
> This is one of the things I believe should be applied right now.
> Maybe we want a cut version of this patch, that exposes this API while
> adjusting KVM_SET_CLOCK / KVM_GET_CLOCK to get in early rather than late?
>    

The first half of the series, at least, is good to go upstream and ready 
for backport.  The trapping and later stuff obviously needs to get some 
upstream testing.
