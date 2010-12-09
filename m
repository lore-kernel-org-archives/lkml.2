Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab0LIQoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:44:15 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42718 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab0LIQoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:44:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FxfWITi4SRePEIiqLR0waN264WlKd7OtcXebwO4aIIrN9n2hcpssFwSerBuCqjlymc
         MFAZ5LPHVt3Vz1He8OMshaS2cUFB7Orfq9tMyxr6m7JKTDEb/KdMkTlRaQ0SzGlMyL40
         nzDSE6tcim7RSv1/N2paz0z+273/iwKvtUfbU=
Date: Fri, 10 Dec 2010 00:47:48 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Florian Mickler <florian@mickler.org>, Ingo Molnar <mingo@elte.hu>,
        =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [regression, 2.6.37-rc1] 'ip link tap0 up' stuck in do_exit()
Message-ID: <20101209164748.GA3218@hack>
References: <20101103062609.GB31163@dastard> <1288768402.2467.665.camel@edumazet-laptop> <20101103103448.GA9169@dastard> <20101103112936.GB9169@dastard> <20101104002140.GA13830@dastard> <20101104054718.GC5210@cr0.nay.redhat.com> <20101208100245.01cf23c5@schatten.dmk.lab> <20101208134116.GA16923@redhat.com> <20101208134712.GB16923@redhat.com> <20101208140822.GA18681@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101208140822.GA18681@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 03:08:22PM +0100, Oleg Nesterov wrote:
>On 12/08, Oleg Nesterov wrote:
>>
>> On 12/08, Oleg Nesterov wrote:
>> >
>> > On 12/08, Florian Mickler wrote:
>> > >
>> > > [ ccing Ingo and Oleg ] as suggested
>> >
>> > Well. Of course I can't explain this bug. But, looking at this email
>> > I do not see amything strange in exit/schedule/etc.
>> >
>> > > > >> > > > This is resulting in the command 'ip link set tap0 up' hanging as a zombie:
>> > > > >> > > >
>> > > > >> > > > root      3005     1  0 16:53 pts/3    00:00:00 /bin/sh /vm-images/qemu-ifup tap0
>> > > > >> > > > root      3011  3005  0 16:53 pts/3    00:00:00 /usr/bin/sudo /sbin/ip link set tap0 up
>> > > > >> > > > root      3012  3011  0 16:53 pts/3    00:00:00 [ip] <defunct>
>> >
>> > That is. ip is a zombie.
>>
>> And. I do not know if this matters or not, but "the command 'ip link
>> set tap0 up' hanging as a zombie" does not look right.
>>
>> This was spawned by
>>
>> > >> > > > if [ -n "$1" ];then
>> > >> > > >         /usr/bin/sudo /sbin/ip link set $1 up
>> > >> > > >         sleep 0.5s
>> > >> > > >         /usr/bin/sudo /usr/sbin/brctl addif $switch $1
>> > >> > > >      exit 0
>> > >> > > > fi
>>
>> The command does not hang. But it forks the child with pid == 3012,
>> this child exits.
>
>Damn, sorry for noise, forgot to mention...
>
>The parent's trace (pid == 3011) can be more useful. Say, if it
>hangs in do_wait(), then the kernel is obviously wrong.
>

Yeah, there is no point that a zombie can trigger a BUG_ON in kenrel.
But it is still interesting to know why it becomes a zombie...

