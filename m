Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab0KRPLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:11:50 -0500
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:58941 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756378Ab0KRPLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:11:49 -0500
X-Greylist: delayed 653 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Nov 2010 10:11:49 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=XBaXiSfiRvd0fElKBQ+ZDcIrLSFVa69fFCYE34um6eKgs+FQrYXG05F/JX51MpuI;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4CE53F81.8070300@earthlink.net>
Date: Thu, 18 Nov 2010 10:00:17 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
References: <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>	 <20101116170312.GA19327@tango.0pointer.de>	 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>	 <20101116181603.GC19327@tango.0pointer.de>	 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>	 <20101116202839.GC27235@tango.0pointer.de>	 <20101116205243.64e4a67a@lxorguk.ukuu.org.uk>	 <AANLkTinSXM5RMH+1FHtkYJiehcyZaxZGs0z4ycLGGE9u@mail.gmail.com>	 <20101117223411.GA23983@tango.0pointer.de>	 <1290033435.2109.1282.camel@laptop>	 <20101117224547.GA26008@tango.0pointer.de> <1290034337.2109.1287.camel@laptop>
In-Reply-To: <1290034337.2109.1287.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79097f562b711540a1372f657901109784350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 05:52 PM, Peter Zijlstra wrote:
> On Wed, 2010-11-17 at 23:45 +0100, Lennart Poettering wrote:
>    
>> On Wed, 17.11.10 23:37, Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
>>
>>      
>>> On Wed, 2010-11-17 at 23:34 +0100, Lennart Poettering wrote:
>>>        
>>>> This should fix things for people with systemd and GNOME. Yes, all
>>>> others are left in the cold. Sorry for that.
>>>>          
>>> Is there an easy opt out for that, other than booting a CONFIG_CGROUP=n
>>> kernel?
>>>        
>> systemd relies on CONFIG_CGROUP=y, since it useses it for service
>> management. It creates its own name=systemd hierarchy for that with no
>> controllers attached. If you turn that off, then systemd will refuse to
>> boot.
>>      
> Do expect distro bugzilla entries when this 'awesome'-ness hits the
> street.
>
>    
>>   However, it does not rely on any of the controllers, and hence you
>> are welcome to disable all cgroup controlls and systemd won't complain.
>>
>> If you want to disable the automatic creation of groups in the 'cpu'
>> hierarchy for user sessions then you can tell pam_systemd that by passing
>> "controllers=" on the PAM config line. ("controllers=cpu" is the implied
>> default.)
>>
>> There's currently no global option to disable the same logic in systemd
>> when it creates 'cpu' cgroups for the various services it runs. However,
>> you can disable that individually with "ControlGroups=cpu:/" in the
>> .service files. I will now add a global option as well.
>>      
> A global knob is a must -- preferably with neon signs on so I can find
> it.  Luckily I don't use this GNOME junk, otherwise I'd have had to ask
> how to revert that crap as well.
>
>
>    
Amen!!



-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



