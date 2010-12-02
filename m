Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab0LBHhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 02:37:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:47592 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab0LBHhC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 02:37:02 -0500
Subject: Re: [PATCH RFC] reduce runqueue lock contention
From: Peter Zijlstra <peterz@infradead.org>
To: frank.rowand@am.sony.com
Cc: Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        tglx <tglx@linutronix.de>
In-Reply-To: <4CF6D694.4030003@am.sony.com>
References: <20100520204810.GA19188@think>
	 <1277114522.1875.469.camel@laptop> <1277117647.1875.503.camel@laptop>
	 <1277125479.1875.510.camel@laptop> <1277213586.1875.704.camel@laptop>
	 <20100622211141.GC21149@elte.hu> <1277284257.1875.820.camel@laptop>
	 <4CF6D694.4030003@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 02 Dec 2010 08:36:49 +0100
Message-ID: <1291275409.4023.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 15:13 -0800, Frank Rowand wrote:
> 
>   If the task to be woken is on a run queue on a different cpu then use
>   cmpxchg() to put it onto a pending try_to_wake_up list on the different
>   cpu.  Then send an interrupt to the different cpu to cause that cpu to
>   call try_to_wake_up() for each process on the try_to_wake_up list. 

Without having looked at the actual code, the described thing cannot
work, try_to_wake_up() has a return value that needs to be passed back.

Also, try_to_wake_up() does load-balancing, you really want to do that
before queueing it on a remote cpu.
