Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab0KPS6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:58:14 -0500
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:33121 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757140Ab0KPS6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:58:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=eWxzheww0ftGBdL+Eh21e0CVNgxkVrKgoHNsHcl4kss+SwrlNQFnKtcjLYENBhoR;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4CE2D41D.3070609@earthlink.net>
Date: Tue, 16 Nov 2010 13:57:33 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Lennart Poettering <mzxreary@0pointer.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
References: <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net> <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net> <20101116015648.GA11534@redhat.com> <1289916171.5169.117.camel@maggy.simson.net> <1289916683.2109.625.camel@laptop> <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com> <20101116170312.GA19327@tango.0pointer.de> <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com> <20101116181603.GC19327@tango.0pointer.de>
In-Reply-To: <20101116181603.GC19327@tango.0pointer.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec796f8905844f0dbfb561da3a06252c1c47350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 01:16 PM, Lennart Poettering wrote:
> On Tue, 16.11.10 09:11, Linus Torvalds (torvalds@linux-foundation.org) wrote:
>
>    
>> On Tue, Nov 16, 2010 at 9:03 AM, Lennart Poettering
>> <mzxreary@0pointer.de>  wrote:
>>      
>>> Binding something like this to TTYs is just backwards.
>>>        
>> Numbers talk, bullshit walks.
>>
>> The numbers have been quoted. The clear interactive behavior has been seen.
>>      
> Here's my super-complex patch btw, to achieve exactly the same thing
> from userspace without involving any kernel or systemd patching and
> kernel-side logic. Simply edit your own ~/.bashrc and add this to the end:
>
>    if [ "$PS1" ] ; then
>            mkdir -m 0700 /sys/fs/cgroup/cpu/user/$$
>            echo $$>  /sys/fs/cgroup/cpu/user/$$/tasks
>    fi
>
> Then, as the superuser do this:
>
>    mount -t cgroup cgroup /sys/fs/cgroup/cpu -o cpu
>    mkdir -m 0777 /sys/fs/cgroup/cpu/user
>
> Done. Same effect. However: not crazy.
>
> I am not sure I myself will find the time to prep some 'numbers' for
> you. They'd be the same as with the kernel patch anyway. But I am sure
> somebody else will do it for you...
>
> Lennart
>
>    
So you have tested this and have a nice demo and numbers to back it up?

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



