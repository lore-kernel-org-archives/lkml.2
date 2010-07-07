Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab0GGUOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 16:14:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755466Ab0GGUOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 16:14:05 -0400
Message-ID: <4C34DF8E.7090501@redhat.com>
Date: Wed, 07 Jul 2010 10:11:58 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: Peter Palfrader <peter@palfrader.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point
 for pvclock
References: <20100701175144.GA2116@kroah.com> <20100701173218.125822294@clark.site> <20100707124731.GJ15122@anguilla.noreply.org> <20100707135140.GI2707@mothafucka.localdomain> <20100707143338.GK15122@anguilla.noreply.org> <20100707181511.GL2707@mothafucka.localdomain>
In-Reply-To: <20100707181511.GL2707@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2010 08:15 AM, Glauber Costa wrote:
> On Wed, Jul 07, 2010 at 04:33:39PM +0200, Peter Palfrader wrote:
>    
>> On Wed, 07 Jul 2010, Glauber Costa wrote:
>>
>>      
>>>> 2.6.32.16 fails to boot on my KVM domains using qemu-kvm 0.11.1.
>>>>
>>>> Bisecting between 2.6.32.14 which worked and .16 turned up this commit
>>>> as the first culprit[0].
>>>>
>>>> The host is still running 2.6.32.14 and has 8 cores on 2 CPUs.  The
>>>> single-cpu KVM domain hangs just after printing 'Write protecting the
>>>> kernel read-only data: 9492k'[1].   On a successful boot this line would
>>>> usually be followed by 'INIT: version 2.86 booting'.
>>>>
>>>> A 2.6.32.16 with this patch reverted boots fine.
>>>>
>>>> If there's any info you need please just ask.
>>>>          
>>      
>>> if you boot with another clocksource, and then switch to kvmclock with the machine already
>>> running, do you see anything strange or suspicious?
>>>        
>> Booting with various clocksource=xxx kernel parameters does not change
>> the behaviour at all, i.e. the boot still hangs.
>>      
> wow, it is really weird then.
>
> that patch shouldn't affect anything outside the pvclock realm.
>    

Unless you added data which is mistakenly in read-only section, I can't 
see how it would affect anything either.  Of course, you have changed 
the data and text size, it is possible this triggered another bug.

What exact section does the per-cpu pvclock data fall into?  It's 
read-only in the kernel, but writeable from the hypervisor.

Also, did this patch arrive before or after the pvclock reboot bugfix?  
Because if the hypervisor is still writing the pvclock page, 
clocksource=xxx would not change that behavior without that fix.

Zach
