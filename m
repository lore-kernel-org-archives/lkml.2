Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab1CIMmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 07:42:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198Ab1CIMmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 07:42:50 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110307021127.GB31188@google.com>
References: <20110307021127.GB31188@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Darren Hart <dvhltc@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] futex: cmpxchg_futex_value_locked API change
Date: Wed, 09 Mar 2011 12:41:27 +0000
Message-ID: <25669.1299674487@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> The cmpxchg_futex_value_locked API was funny in that it returned either
> the original, user-exposed futex value OR an error code such as -EFAULT.
> This was confusing at best, and could be a source of livelocks in places
> that retry the cmpxchg_futex_value_locked after trying to fix the issue
> by running fault_in_user_writeable().
> 
> This change makes the cmpxchg_futex_value_locked API more similar to the
> get_futex_value_locked one, returning an error code and updating the
> original value through a reference argument.
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>

Acked-by: David Howells <dhowells@redhat.com> [FRV]
