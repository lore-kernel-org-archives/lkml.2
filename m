Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0IQWKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 18:10:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab0IQWKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 18:10:14 -0400
Message-ID: <4C93E734.4040208@redhat.com>
Date: Fri, 17 Sep 2010 12:09:56 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 10/35] Fix deep C-state TSC desynchronization
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-11-git-send-email-zamsden@redhat.com> <4C8F3C03.50306@siemens.com> <4C904685.9090402@redhat.com> <4C907F3D.6070709@web.de> <20100915123215.GC3688@mothafucka.localdomain> <4C911002.8060807@web.de>
In-Reply-To: <4C911002.8060807@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2010 08:27 AM, Jan Kiszka wrote:
> Am 15.09.2010 14:32, Glauber Costa wrote:
>    
>> On Wed, Sep 15, 2010 at 10:09:33AM +0200, Jan Kiszka wrote:
>>      
>>>> In any case, I'll proceed with the forcing of unstable TSC and HPET
>>>> clocksource and see what happens.
>>>>          
>>> I tried that before, but it did not trigger the issue that kvm-clock
>>> guests no longer boot properly. This only happens if the TSC is marked
>>> unstable.
>>>        
>> even artificially marked unstable ?
>>
>>      
> Yes. As soon as I hack tsc_unstable to 1, things go wrong. When I hack
> it back to 0, guest that wants kvm-clock boots again and seem to run fine.
>
> This is issue #2, I guess. Issue #2 remains that the TSC is marked
> unstable. I have the feeling that this is bogus, maybe due to lacking
> suspend/resume awareness? The tsc clocksource does
>
> 	clocksource_tsc.cycle_last = 0;
>
> on resume...
>
> Jan
>
>    

I have now reproduced this exactly.  Shouldn't be long before I have a 
solution.

Zach
