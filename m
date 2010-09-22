Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab0IVQkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 12:40:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:34146 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab0IVQkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 12:40:06 -0400
Subject: Re: [PATCH] avoid second smp_processor_id() call in
 __touch_watchdog
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
In-Reply-To: <20100922162730.GC5302@nowhere>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
	 <20100818123346.02028e96.akpm@linux-foundation.org>
	 <20100922090012.GA5459@swordfish.minsk.epam.com>
	 <20100922162730.GC5302@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Sep 2010 18:39:19 +0200
Message-ID: <1285173559.2275.1024.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 18:27 +0200, Frederic Weisbecker wrote:
> 
> I'm not sure we want this. This is called by the watchdog internally,
> from the timer or the cpu bound thread, so we probably should better
> keep __get_cpu_var() because it checks that we are not in a preemptable
> section. 

The smp_processor_id() right at the start already does that.

That said, I doubt it really matter one way or the other, compilers have
been known to do CSE for quite a while.
