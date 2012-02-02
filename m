Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab2BBRZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:25:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab2BBRZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:25:01 -0500
Message-ID: <4F2AC69B.7000704@redhat.com>
Date: Thu, 02 Feb 2012 19:23:39 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Christoph Lameter <cl@linux.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com> <1327591185.2446.102.camel@twins> <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com> <1328117722.2446.262.camel@twins> <20120201184045.GG2382@linux.vnet.ibm.com> <alpine.DEB.2.00.1202011404500.2074@router.home> <20120201201336.GI2382@linux.vnet.ibm.com> <4F2A58A1.90800@redhat.com> <20120202153437.GD2518@linux.vnet.ibm.com> <4F2AB66C.2030309@redhat.com> <20120202170134.GM2518@linux.vnet.ibm.com>
In-Reply-To: <20120202170134.GM2518@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 07:01 PM, Paul E. McKenney wrote:
> > 
> > It's not called (since the cpu is not idle).  Instead we call
> > rcu_virt_note_context_switch().
>
> Frederic's work checks to see if there is only one runnable user task
> on a given CPU.  If there is only one, then the scheduling-clock interrupt
> is turned off for that CPU, and RCU is told to ignore it while it is
> executing in user space.  Not sure whether this covers KVM guests.

Conceptually it's the same.  Maybe it needs adjustments, since kvm
enters a guest in a different way than the kernel exits to userspace.

> In any case, this is not yet in mainline.

Let me know when it's in, and I'll have a look.

-- 
error compiling committee.c: too many arguments to function

