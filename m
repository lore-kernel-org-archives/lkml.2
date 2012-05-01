Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab2EAAdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:33:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:39051 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756932Ab2EAAdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:33:49 -0400
Message-ID: <1335832418.20866.95.camel@pasglop>
Subject: Re: linux-next ppc64: RCU mods cause __might_sleep BUGs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hughd@google.com>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Tue, 01 May 2012 10:33:38 +1000
In-Reply-To: <alpine.LSU.2.00.1204301451270.2986@eggly.anvils>
References: <alpine.LSU.2.00.1204301451270.2986@eggly.anvils>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-30 at 15:37 -0700, Hugh Dickins wrote:
> 
> BUG: sleeping function called from invalid context at include/linux/pagemap.h:354
> in_atomic(): 0, irqs_disabled(): 0, pid: 6886, name: cc1

Hrm ... in_atomic and irqs_disabled are both 0 ... so yeah it smells
like a preempt count problem... odd.

Did you get a specific bisect target yet ?

Cheers,
Ben.

> Call Trace:
> [c0000001a99f78e0] [c00000000000f34c] .show_stack+0x6c/0x16c (unreliable)
> [c0000001a99f7990] [c000000000077b40] .__might_sleep+0x11c/0x134
> [c0000001a99f7a10] [c0000000000c6228] .filemap_fault+0x1fc/0x494
> [c0000001a99f7af0] [c0000000000e7c9c] .__do_fault+0x120/0x684
> [c0000001a99f7c00] [c000000000025790] .do_page_fault+0x458/0x664
> [c0000001a99f7e30] [c000000000005868] handle_page_fault+0x10/0x30
> 
> I've plenty more examples, most of them from page faults or from kswapd;
> but I don't think there's any more useful information in them.
> 
> Anything I can try later on? 

