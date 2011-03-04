Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab1CDW5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 17:57:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520Ab1CDW5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 17:57:11 -0500
Message-ID: <4D716E43.4080909@redhat.com>
Date: Fri, 04 Mar 2011 17:57:07 -0500
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: Nikola Ciprich <extmaillist@linuxbox.cz>, Avi Kivity <avi@redhat.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
 boot
References: <20110228152823.GF29840@pcnci.linuxbox.cz>	 <4D6BC5CA.8060004@redhat.com> <20110228171550.GA2173@nik-comp.lan>	 <4D6EF536.305@redhat.com> <20110303070652.GG29840@pcnci.linuxbox.cz>	 <4D6FFE5D.1030401@redhat.com> <20110303210647.GA27691@nik-comp.lan>	 <4D700F09.9000002@redhat.com> <20110303220155.GB27691@nik-comp.lan>	 <4D7101AF.6060009@redhat.com>  <20110304182733.GA2867@nik-comp.lan> <1299265762.11618.140.camel@mothafucka.localdomain>
In-Reply-To: <1299265762.11618.140.camel@mothafucka.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 02:09 PM, Glauber Costa wrote:
> On Fri, 2011-03-04 at 19:27 +0100, Nikola Ciprich wrote:
>    
>> Hello Zachary,
>>
>>      
>>> You don't see any messages about TSC being unstable or switching
>>> clocksource after loading the KVM module?  And you are not suspending
>>> the host or anything?
>>>        
>> no messages, no suspending, nothing.
>>
>>
>>      
>>> Can you try using "processor.max_cstate=1" on the host as a kernel
>>> parameter and see if it makes a difference?
>>>        
>> I tried it, no change..
>> n.
>>      
> Zach,
>
> I don't understand 100 % the logic behind all your tsc changes.
> But kvm-clock-wise, most of the problems we had in the past were related
> to the difference in resolution between the tsc and the host clocksource
> (hpet, acpi_pm, etc), which in his case, it is a non-issue.
>
> It does seem to me like some compensation logic kicked in, dismantling
> an otherwise good tsc. He does have nonstop_tsc, which means it can't
> get any better.
>
> One thing I noticed when reading the culprit patch in bisect, is that in
> vcpu_load(), there were previously a call to
>
>   kvm_request_guest_time_update(vcpu)
>
> that was removed without a counterpart addition. Any idea about why it
> was done?
>    

That's probably the source of the bug... I've been looking for that 
exact line, though, and I can't find it missing.
