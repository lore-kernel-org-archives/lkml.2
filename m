Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab1FHTpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:45:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:44704 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1FHTpq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:45:46 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20110608191758.GA12457@elte.hu>
References: <20110606155236.GA7374@elte.hu>
	 <1307376039.2322.164.camel@twins> <20110606160810.GA16636@elte.hu>
	 <1307376771.2322.168.camel@twins> <20110606161749.GA22157@elte.hu>
	 <4DED0292.1040605@die-jansens.de> <4DED0423.4050904@die-jansens.de>
	 <20110606170725.GD2391@elte.hu> <1307380311.2322.223.camel@twins>
	 <1307548218.3941.6.camel@twins>  <20110608191758.GA12457@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Jun 2011 21:45:29 +0200
Message-ID: <1307562329.3941.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 21:17 +0200, Ingo Molnar wrote:
> Hm, the no-wakeup aspect seems rather useful.
> 
> Could we perhaps remove console_sem and replace it with a mutex and 
> do something like this with a mutex and its ->wait_lock?
> 
> We'd have two happy side effects:
> 
>  - we'd thus remove one of the last core kernel semaphore users
>  - we'd gain lockdep coverage for console locking as a bonus ... 

The mutex thing is more complex due to the mutex fast path, the
advantage of the semaphore is its simple implementation that always
takes the internal lock.

I guess I can make it happen, but its a tad more tricky.
