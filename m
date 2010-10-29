Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761731Ab0J2ToU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:44:20 -0400
Received: from canuck.infradead.org ([134.117.69.58]:43124 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761718Ab0J2ToS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:44:18 -0400
Subject: Re: [tip:x86/urgent] x86-32: Restore irq stacks NUMA-aware
 allocations
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, brgerst@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-5c1eb08936693cd78c71164c8bea0b086ae72c67@git.kernel.org>
References: <1288276854.2649.607.camel@edumazet-laptop>
	 <tip-5c1eb08936693cd78c71164c8bea0b086ae72c67@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 29 Oct 2010 20:32:26 +0200
Message-ID: <1288377146.1988.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 06:43 +0000, tip-bot for Eric Dumazet wrote:
> +       irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
> +                                              THREAD_FLAGS,
> +                                              THREAD_ORDER)); 

Shouldn't we be checking for a NULL return from alloc_pages_node()
before calling page_address() on it?
