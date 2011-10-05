Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104Ab1JEIxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 04:53:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43166 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659Ab1JEIxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 04:53:40 -0400
Subject: Re: big picture UDP/IP performance question re 2.6.18 -> 2.6.32
From: Eric Dumazet <eric.dumazet@gmail.com>
To: starlight@binnacle.cx
Cc: Joe Perches <joe@perches.com>, Christoph Lameter <cl@gentwo.org>,
        Serge Belyshev <belyshev@depni.sinp.msu.ru>,
        Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <stephen.hemminger@vyatta.com>
In-Reply-To: <6.2.5.6.2.20111005025227.03a9d9f0@binnacle.cx>
References: <6.2.5.6.2.20111005025227.03a9d9f0@binnacle.cx>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 10:53:52 +0200
Message-ID: <1317804832.2473.25.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 05 octobre 2011 à 02:58 -0400, starlight@binnacle.cx a
écrit :
> Final note:
> 
> I had captured latency measurements for
> two of the three kernels.  Just ran
> 2.6.18(rhel5) and the results are
> stunning.  The older kernel is much,
> much better then the newer kernel.
> 
> Average latency is three times better
> and the standard deviation is six
> time better.  As in 300% and 600%.
> 
> Latency here is the time it takes
> a packet to travel from the kernel
> (where it is timestamped) till it
> reaches the final consumption point
> in the application.
> 
> Makes me think that the old kernel
> is better at keeping caches hot and
> scheduling woken threads on the same
> cores as the threads that triggered
> them.
> 

Note :

Your results are from a combination of a user application and kernel
default strategies.

On other combinations, results can be completely different.

A wakeup strategy is somewhat tricky : 

- Should we affine or not.
- Should we queue the wakeup on a remote CPU, to keep scheduler data hot
in a single cpu cache.
- Should we use RPS/RFS to queue the packet to another CPU before  even
handling it in our stack, to keep network data hot in a single cpu
cache. (check Documentation/networking/scaling.txt)

At least, with recent kernels, we have many available choices to tune a
workload.



