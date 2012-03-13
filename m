Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab2CMHOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:14:43 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57002 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab2CMHOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:14:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120312.235002.344576347742686103.davem@davemloft.net>
References: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
 <20120312.225302.488696931454771146.davem@davemloft.net> <CAHqTa-3DiZhd_yoRTzp2Np0Rp=_zrfL7CbN_twu+ZZeu7f4ENg@mail.gmail.com>
 <20120312.235002.344576347742686103.davem@davemloft.net>
From: Avery Pennarun <apenwarr@gmail.com>
Date: Tue, 13 Mar 2012 03:14:21 -0400
Message-ID: <CAHqTa-3sMRJ0p7driNF+d=f_NZNCF-+TWnCSNO2efEdfv0ayVQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Persist printk buffer across reboots.
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, josh@joshtriplett.org,
        paulmck@linux.vnet.ibm.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        fdinitto@redhat.com, hannes@cmpxchg.org, olaf@aepfle.de,
        paul.gortmaker@windriver.com, tj@kernel.org, hpa@linux.intel.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 2:50 AM, David Miller <davem@davemloft.net> wrote:
> The idea is that you call prom_retain() before you take a look at what
> physical memory is available in the kernel, and the firmware takes
> this physical chunk out of those available memory lists upon
> prom_retain() success.

This sounds like exactly the API I would have wanted, however:

1) It's only available in arch/sparc so I can't test my patch if I try
to use it;
2) There's nobody that calls it so it might not work;
3) I don't understand the API so I'm not really confident that
reserving memory this way will actually prevent it from being seen by
the kernel.

In short, I think I would screw it up.

On the other hand, as written it seems like my code would also work on
sparc, and would work with more than one kind of memory area if more
than one module chose to use this technique.  (ie. Since the prober
actually reserves memory, the next prober would necessarily reserve a
different bit of memory, and as long as you're using the same kernel
as before and you do all reservations before enabling interrupts, you
should get consistent results.)

I suppose I could move the actual probe-and-allocate code somewhere
(bootmem.c?  memblock.c?) and add a 'name' parameter to it which is
ignored in the generic implementation.  Then someone could write an
arch-specific implementation.  Would that work?  If so, please
recommend which file to put the generic implementation in :)

Thanks,

Avery
