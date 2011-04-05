Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1DEJJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 05:09:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab1DEJJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 05:09:27 -0400
Message-ID: <4D9ADC1D.5010109@redhat.com>
Date: Tue, 05 Apr 2011 12:08:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: ben@iagu.net, Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Richard Cochran <richard.cochran@omicron.at>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] posix-timers: RCU conversion
References: <AANLkTikZZ4MXZjx_+6u-vKVSgxULQo2BkQKRO6K_vzFy@mail.gmail.com>	 <20110318123031.GB6066@8bytes.org>	 <AANLkTin2k1ZSLa0NG6pKBvHYnKEV21t8pEqzeJWNn_rR@mail.gmail.com>	 <4D871F6C.40207@redhat.com>	 <AANLkTintxnKRQ4rD4Wo8_MHU4yJVzYaRhR=GjnDMGwNj@mail.gmail.com>	 <AANLkTin8ZoUAVR2ajoV6cBFiUSe_Dof0_k60dcAGW3r-@mail.gmail.com>	 <4D875842.9050308@redhat.com>	 <AANLkTikWQS281kTtJ32-qo5U+w_BAak7qUwVhUQgOxxv@mail.gmail.com>	 <4D8773AA.8030408@redhat.com>	 <AANLkTin3Si1EAa=Va6f45vW-tYQ1Yk8dETXpHJHHHkxe@mail.gmail.com>	 <1300726498.2884.493.camel@edumazet-laptop>	<4D8784A9.8040303@redhat.com>	 <1300727545.2884.513.camel@edumazet-laptop>	 <AANLkTinn7OKKKvBYe7KWsrReuYDdma5+8gHJHXdCacDY@mail.gmail.com>	 <1300746429.2837.20.camel@edumazet-laptop>	 <1300777760.2837.38.camel@edumazet-laptop>	 <AANLkTik-Rt-Fy-2fKQTr2JBB9f7U2cbc0FmTZOoXc1+5@mail.gmail.com>	 <4D887B6A.2020102@redhat.com> <1301993300.2225.26.camel@twins>	 <4D9AD92D.401@redhat.com> <1301994229.2225.30.camel@twins>
In-Reply-To: <1301994229.2225.30.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2011 12:03 PM, Peter Zijlstra wrote:
> On Tue, 2011-04-05 at 11:56 +0300, Avi Kivity wrote:
> >
> >  Could be waking up due to guest wakeups, or qemu internal wakeups
> >  (display refresh) or due to guest timer sources which are masked away in
> >  the guest (if that's the case we should optimize it away).
>
> Right, so I guess we're all clutching at straws here :-)
>
> Ben how usable is that system when its in that state? Could you run a
> function trace or a trace with all kvm and sched trace-events enabled?

Ben, to do that, look up http://www.linux-kvm.org/page/Tracing; the 
command for combined sched/kvm tracing is

# trace-cmd record -b 20000 -e kvm -e sched



-- 
error compiling committee.c: too many arguments to function

