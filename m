Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab1HAJzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:55:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:35507 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab1HAJzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:55:12 -0400
Subject: Re: [PATCH] perf: powerpc: Disable pagefaults during callchain
 stack read
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: benh@kernel.crashing.org, anton@samba.org, acme@ghostprotocols.net,
        mingo@elte.hu, paulus@samba.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1312059200-11563-1-git-send-email-dsahern@gmail.com>
References: <1312059200-11563-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 11:59:52 +0200
Message-ID: <1312192792.2617.381.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-30 at 14:53 -0600, David Ahern wrote:
> A page fault occurred walking the callchain while creating a perf
> sample for the context-switch event. To handle the page fault the
> mmap_sem is needed, but it is currently held by setup_arg_pages.
> (setup_arg_pages calls shift_arg_pages with the mmap_sem held.
> shift_arg_pages then calls move_page_tables which has a cond_resched
> at the top of its for loop - hitting that cond_resched is what caused
> the context switch.)
> 
> This is an extension of Anton's proposed patch:
> https://lkml.org/lkml/2011/7/24/151
> adding case for 32-bit ppc.
> 
> Tested on the system that first generated the panic and then again
> with latest kernel using a PPC VM. I am not able to test the 64-bit
> path - I do not have H/W for it and 64-bit PPC VMs (qemu on Intel)
> is horribly slow.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Anton Blanchard <anton@samba.org> 

Hmm, Paul, didn't you fix something like this early on? Anyway, I've no
objections since I'm really not familiar enough with the PPC side of
things.

