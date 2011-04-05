Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1DEJEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 05:04:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:38365 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab1DEJEA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 05:04:00 -0400
Subject: Re: [PATCH] posix-timers: RCU conversion
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: ben@iagu.net, Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Richard Cochran <richard.cochran@omicron.at>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <4D9AD92D.401@redhat.com>
References: <AANLkTikZZ4MXZjx_+6u-vKVSgxULQo2BkQKRO6K_vzFy@mail.gmail.com>
	 <20110318123031.GB6066@8bytes.org>
	 <AANLkTin2k1ZSLa0NG6pKBvHYnKEV21t8pEqzeJWNn_rR@mail.gmail.com>
	 <4D871F6C.40207@redhat.com>
	 <AANLkTintxnKRQ4rD4Wo8_MHU4yJVzYaRhR=GjnDMGwNj@mail.gmail.com>
	 <AANLkTin8ZoUAVR2ajoV6cBFiUSe_Dof0_k60dcAGW3r-@mail.gmail.com>
	 <4D875842.9050308@redhat.com>
	 <AANLkTikWQS281kTtJ32-qo5U+w_BAak7qUwVhUQgOxxv@mail.gmail.com>
	 <4D8773AA.8030408@redhat.com>
	 <AANLkTin3Si1EAa=Va6f45vW-tYQ1Yk8dETXpHJHHHkxe@mail.gmail.com>
	 <1300726498.2884.493.camel@edumazet-laptop>	<4D8784A9.8040303@redhat.com>
	 <1300727545.2884.513.camel@edumazet-laptop>
	 <AANLkTinn7OKKKvBYe7KWsrReuYDdma5+8gHJHXdCacDY@mail.gmail.com>
	 <1300746429.2837.20.camel@edumazet-laptop>
	 <1300777760.2837.38.camel@edumazet-laptop>
	 <AANLkTik-Rt-Fy-2fKQTr2JBB9f7U2cbc0FmTZOoXc1+5@mail.gmail.com>
	 <4D887B6A.2020102@redhat.com> <1301993300.2225.26.camel@twins>
	 <4D9AD92D.401@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Apr 2011 11:03:49 +0200
Message-ID: <1301994229.2225.30.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-05 at 11:56 +0300, Avi Kivity wrote:
> 
> Could be waking up due to guest wakeups, or qemu internal wakeups 
> (display refresh) or due to guest timer sources which are masked away in 
> the guest (if that's the case we should optimize it away).

Right, so I guess we're all clutching at straws here :-)

Ben how usable is that system when its in that state? Could you run a
function trace or a trace with all kvm and sched trace-events enabled?


