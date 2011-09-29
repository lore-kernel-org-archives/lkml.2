Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1I2His (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 03:38:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52530 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1I2Hir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 03:38:47 -0400
Subject: Re: Jump Label initialization
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        David Daney <ddaney@caviumnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 29 Sep 2011 09:37:59 +0200
In-Reply-To: <4E83D49C.9080809@goop.org>
References: <4E83D49C.9080809@goop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317281879.22384.1.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 19:14 -0700, Jeremy Fitzhardinge wrote:
> Hi all,
> 
> I'm trying to use the jump label machinery as part of the pv ticketlock
> work I'm doing on x86.
> 
> The problem I'm having at the moment is that I do my spinlock setup in
> smp_prepare_boot_cpu(), which happens before jump_label_init() gets
> called, and so the latter goes and nops out all my enabled jump label key.
> 
> I'm experimenting at the moment with a patch to allow
> jump_label_enable() to be called fairly early, and have that be
> respected by jump_label_init().  I'm doing this by replacing
> arch_jump_label_poke_text_early() with
> arch_jump_label_transform_early(), which shares most of its code with
> its non-early variant, except that it expects to run in a pre-SMP
> environment.
> 
> Does this seem plausible? (I haven't tested it yet.)
> 
> The x86, mips and sparc patches are fairly simple; I forgot to look at
> powerpc, and I didn't fully investigate s390.
> 
> While my current use-case is x86-specific, it seems generally useful to
> make the jump_label machinery available as early as possible. I wonder
> if you have any suggestions about how to handle this?

I also remember talking to Jason about a way to initialize a jump label
enabled, instead of the default disabled.

So yeah, I think your stuff would be useful..
