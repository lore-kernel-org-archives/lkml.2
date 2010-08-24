Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0HXJDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:03:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:47661 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab0HXJDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:03:38 -0400
Message-ID: <4C73899A.304@kernel.org>
Date: Tue, 24 Aug 2010 10:58:02 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: general protection fault: 0000 [#1] PREEMPT SMP
References: <20100813134756.GA5235@swordfish.minsk.epam.com>
In-Reply-To: <20100813134756.GA5235@swordfish.minsk.epam.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 24 Aug 2010 09:03:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/13/2010 03:47 PM, Sergey Senozhatsky wrote:
> [   29.943019]  [<ffffffff81065893>] lock_acquire+0x97/0xb6
..
> [   29.943257]  [<ffffffff8137568d>] _raw_spin_lock_irqsave+0x4e/0x60
..
> [   29.943376]  [<ffffffff8137145b>] percpu_counter_hotcpu_callback+0x3e/0x93

It's getting gpf at spin_lock_irqsave(&fbc->lock) in
percpu_counter_hotplug_callback().  percpu_counter keeps track of all
the allocated percpu counters and walk them on cpu up/down events.
It's most likely one of its users freed or corrupted the percpu
counter structure without properly destroying it.  Adding debugobj is
probably the best way to track down the offending user.

Thanks.

-- 
tejun
