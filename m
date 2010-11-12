Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab0KLMUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 07:20:04 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:42300 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab0KLMUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 07:20:01 -0500
Date: Fri, 12 Nov 2010 17:49:32 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 04/20] x86/ticketlock: make large and small ticket
 versions of spin_lock the same
Message-ID: <20101112121932.GA30016@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
 <5b3cbff3a6e96a085651f140a0525be80a4df8ba.1288794124.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b3cbff3a6e96a085651f140a0525be80a4df8ba.1288794124.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 10:59:45AM -0400, Jeremy Fitzhardinge wrote:
> Make the bulk of __ticket_spin_lock look identical for large and small
> number of cpus.

[snip]

>  #if (NR_CPUS < 256)
>  static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
>  {
> -	register union {
> -		struct __raw_tickets tickets;
> -		unsigned short slock;
> -	} inc = { .slock = 1 << TICKET_SHIFT };
> +	register struct __raw_tickets inc = { .tail = 1 };

[snip]

>  #else
>  static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
>  {
> -	unsigned inc = 1 << TICKET_SHIFT;
> -	__ticket_t tmp;
> +	register struct __raw_tickets inc = { .tickets.tail = 1 };

s/.tickets//?

Otherwise I get a compile error for NR_CPUS > 256, with just 4 patches applied.

- vatsa
