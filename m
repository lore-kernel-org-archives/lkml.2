Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab0KQIb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:31:58 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:45537 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab0KQIb5 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:12:1>);
	Wed, 17 Nov 2010 03:31:57 -0500
Message-Id: <4CE3A1060200007800022B04@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 17 Nov 2010 08:31:50 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
        "Eric Dumazet" <dada1@cosmosbay.com>, <xiyou.wangcong@gmail.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Nick Piggin" <npiggin@kernel.dk>,
        "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
        "Linux Virtualization" <virtualization@lists.linux-foundation.org>,
        "Xen-devel" <xen-devel@lists.xensource.com>,
        "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
        "Avi Kivity" <avi@redhat.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 13/14] x86/ticketlock: add slowpath logic
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com><cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <97ed99ae9160bdb6477284b333bd6708fb7a19cb.1289940821.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <97ed99ae9160bdb6477284b333bd6708fb7a19cb.1289940821.git.jeremy.fitzhardinge@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.11.10 at 22:08, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> +static inline void __ticket_enter_slowpath(struct arch_spinlock *lock)
> +{
> +	if (sizeof(lock->tickets.tail) == sizeof(u8))
> +		asm (LOCK_PREFIX "orb %1, %0"
> +		     : "+m" (lock->tickets.tail)
> +		     : "i" (TICKET_SLOWPATH_FLAG) : "memory");
> +	else
> +		asm (LOCK_PREFIX "orw %1, %0"
> +		     : "+m" (lock->tickets.tail)
> +		     : "i" (TICKET_SLOWPATH_FLAG) : "memory");
> +}

Came only now to mind: Here and elsewhere, did you try using
%z0 to have gcc produce the opcode suffix character, rather
than having these somewhat ugly if()-s?

Jan

