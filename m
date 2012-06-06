Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2FFHm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:42:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52591 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751457Ab2FFHm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:42:27 -0400
Message-ID: <1338968546.8241.2.camel@joe2Laptop>
Subject: Re: [PATCH] printk: Shrink printk_sched buffer size, eliminate it
 when !CONFIG_PRINTK
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 06 Jun 2012 00:42:26 -0700
In-Reply-To: <20120606073321.GH17808@gmail.com>
References: <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
	 <1337096141.27694.82.camel@twins> <1337193010.27694.146.camel@twins>
	 <CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
	 <1337468148.573.139.camel@twins>
	 <CANQmPXhN92i9E8HqxE7pqz=kOwtn5Mz0crW37H6qs+XD420Yuw@mail.gmail.com>
	 <20120523150359.GB26974@gmail.com> <1337787838.1734.15.camel@joe2Laptop>
	 <20120523155003.GA8202@gmail.com> <1338315431.18974.10.camel@joe2Laptop>
	 <20120606073321.GH17808@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 09:33 +0200, Ingo Molnar wrote:
> The change makes sense but the further proliferation of #ifdefs 
> is rather ugly and shows confusion: fundamentally, if we are 
> going to cut out more printk functionality in the !CONFIG_PRINTK 
> we might as well disable the whole thing, not just the 
> printk_sched bits.

I fundamentally agree, but I (or another sucker) get
around to actually refactoring printk into multiple
logical components, this is the simplest way to go
because it's guaranteed to work.

When it's refactored, a lot of the CONFIG tests should
go away.

