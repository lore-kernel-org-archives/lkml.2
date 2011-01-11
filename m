Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab1AKRZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 12:25:03 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47015 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab1AKRZA (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 11 Jan 2011 12:25:00 -0500
Date: Tue, 11 Jan 2011 12:21:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Nick Piggin <npiggin@kernel.dk>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@novell.com>, Eric Dumazet <dada1@cosmosbay.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [Xen-devel] [PATCH 01/14] x86/ticketlock: clean up types and
 accessors
Message-ID: <20110111172100.GA14017@dumpdata.com>
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <92d21a90d4e27db4b46dbacd58ef67719acd0185.1289940821.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92d21a90d4e27db4b46dbacd58ef67719acd0185.1289940821.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
>  {
> -	int tmp = ACCESS_ONCE(lock->slock);
> +	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
>  
> -	return !!(((tmp >> TICKET_SHIFT) ^ tmp) & ((1 << TICKET_SHIFT) - 1));
> +	return !!(tmp.tail ^ tmp.head);

Does it make sense to mask it here it here with TICKET_MASK as it was done before?
