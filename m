Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab2BEMGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 07:06:32 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48252 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2BEMGb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 07:06:31 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <alpine.DEB.2.00.1202021124520.6338@router.home>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
	<1327591185.2446.102.camel@twins>
	<CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com>
	<1328117722.2446.262.camel@twins>
	<20120201184045.GG2382@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1202011404500.2074@router.home>
	<20120201201336.GI2382@linux.vnet.ibm.com>
	<4F2A58A1.90800@redhat.com>
	<20120202153437.GD2518@linux.vnet.ibm.com>
	<4F2AB66C.2030309@redhat.com>
	<20120202170134.GM2518@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1202021124520.6338@router.home>
Date: Sun, 5 Feb 2012 14:06:29 +0200
Message-ID: <CAOtvUMdCZpQuSvutKHpMxthktTm_VkA1R99yxpNhxpsYN9wTRQ@mail.gmail.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Christoph Lameter <cl@linux.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 7:25 PM, Christoph Lameter <cl@linux.com> wrote:
> On Thu, 2 Feb 2012, Paul E. McKenney wrote:
>
>> Frederic's work checks to see if there is only one runnable user task
>> on a given CPU.  If there is only one, then the scheduling-clock interrupt
>> is turned off for that CPU, and RCU is told to ignore it while it is
>> executing in user space.  Not sure whether this covers KVM guests.
>>
>> In any case, this is not yet in mainline.
>
> Sounds great. Is there any plan on when to merge it? Where are the most up
> to date patches vs mainstream?
>


Frederic has the latest version in a git tree here:

git://github.com/fweisbec/linux-dynticks.git
       nohz/cpuset-v2-pre-20120117

It's on top latest rcu/core.

I've been playing with it for some time now. It works very well, considering the
early  state - there are  a couple of TODO items listed here:
https://tglx.de/~fweisbec/TODO-nohz-cpusets and I've seen an assert from
the  RCU code once.

Also, there is some system stuff "in the way" so to speak, of getting the full
benefits:

I had to disable the clock source watchdog (I'm testing in a KVM VM, so I guess
the TSC is not stable), the vmstat_stats work on that CPU and to (try
to) fix what
looks like a bug in  the NOHZ timer code.

But the good news is that with these hacks applied I managed to run a 100%
CPU task  with  zero interrupts  (ticks or  otherwise) on an isolated cpu.

Disregarding TLB overhead, you get bare metal performance with Linux user
space manageability and  debug capabilities.  Pretty magical really: It's like
eating your cake and having it too :-)

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
