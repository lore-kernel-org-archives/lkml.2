Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0EHX2y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 19:28:54 -0400
Received: from crca.org.au ([74.207.252.120]:46549 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab0EHX2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 19:28:53 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BE5F3B2.6070901@crca.org.au>
Date: Sun, 09 May 2010 09:28:50 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Linux Power Management List <linux-pm@lists.osdl.org>
Subject: Re: 2.6.33 & 2.6.34-rc6: Huge number of Load Balancing tick wakeups.
References: <4BE4F5DF.70903@crca.org.au> <alpine.LFD.2.00.1005081511550.4103@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005081511550.4103@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len.

On 09/05/10 05:16, Len Brown wrote:
> (linux-pm cc'd)
>
>> I'm seeing a huge number of load balancing tick wakeups, with both 2.6.33 and
>> current git (f1c448e0a9e99c76f4ece368714fb35a40a8daba).
>>
>> This has been reported as a bug in some distros:
>>
>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=521944
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/524281
>
> Unclear if your sighting is the same as those two.
>
> What do you see if vmware is not present?

I still see a huge number, just not as huge. The number of load 
balancing ticks seems to increase with the number of ticks from other 
sources. Without vmware running I got:

Cn	          Avg residency
C0 (cpu running)        (14.5%)
polling		  0.2ms ( 0.0%)
C1 mwait	  0.0ms ( 0.0%)
C2 mwait	  0.1ms ( 1.7%)
C4 mwait	  1.1ms (83.8%)
P-states (frequencies)
Turbo Mode     1.2%
   2.21 Ghz     0.0%
   1.60 Ghz     0.0%
   1200 Mhz     0.1%
    800 Mhz    98.7%
Wakeups-from-idle per second : 907.4	interval: 15.0s
no ACPI power usage estimate available
Top causes for wakeups:
   42.1% (435.6)   [kernel scheduler] Load balancing tick
   21.2% (219.6)   [extra timer interrupt]
   10.2% (105.6)   plugin-containe
    9.5% ( 98.1)   pulseaudio
    1.7% ( 17.9)   [Rescheduling interrupts] <kernel IPI>
    1.7% ( 17.1)   [iwl3945] <interrupt>
    1.4% ( 14.8)   [kernel core] hrtimer_start (tick_sched_timer)
    1.4% ( 14.3)   [ata_piix] <interrupt>

> What do you see if you boot single user mode,
> how about with maxcpusx=1?

I'll try those later today and get back to you with more info.

Regards,

Nigel

> cheers,
> Len Brown, Intel Open Source Technology Center
>
>> PowerTOP 1.12   (C) 2007, 2008 Intel Corporation
>>
>> Collecting data for 15 seconds
>>
>>
>> Your CPU supports the following C-states : C1 C2 C3 C4
>> Your BIOS reports the following C-states : C1 C2 C4
>> Cn                Avg residency
>> C0 (cpu running)        (40.8%)
>> polling           0.7ms ( 0.1%)
>> C1 mwait          0.0ms ( 0.0%)
>> C2 mwait          0.1ms ( 3.2%)
>> C4 mwait          0.4ms (56.0%)
>> P-states (frequencies)
>> Turbo Mode     7.3%
>>    2.21 Ghz     0.7%
>>    1.60 Ghz     0.8%
>>    1200 Mhz     0.9%
>>     800 Mhz    90.3%
>> Wakeups-from-idle per second : 1727.3   interval: 15.0s
>> no ACPI power usage estimate available
>> Top causes for wakeups:
>>    53.0% (1983.1)   [kernel scheduler] Load balancing tick
>>    27.7% (1035.1)   vmware-vmx
>>     8.8% (330.6)   [extra timer interrupt]
>>     2.3% ( 85.5)   [TLB shootdowns]<kernel IPI>
