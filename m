Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1IBOsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 10:48:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50945 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab1IBOss convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 10:48:48 -0400
Subject: Re: [PATCH 10/13] xen/pvticket: allow interrupts to be enabled
 while blocking
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Fri, 02 Sep 2011 16:48:25 +0200
In-Reply-To: <17a0f6177a71190dad30a6dcd1da93bec13a7836.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
	 <17a0f6177a71190dad30a6dcd1da93bec13a7836.1314922370.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314974905.1861.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 17:55 -0700, Jeremy Fitzhardinge wrote:
> +       /* Make sure an interrupt handler can't upset things in a
> +          partially setup state. */
>         local_irq_save(flags);
>  
> +       /*
> +        * We don't really care if we're overwriting some other
> +        * (lock,want) pair, as that would mean that we're currently
> +        * in an interrupt context, and the outer context had
> +        * interrupts enabled.  That has already kicked the VCPU out
> +        * of xen_poll_irq(), so it will just return spuriously and
> +        * retry with newly setup (lock,want).
> +        *
> +        * The ordering protocol on this is that the "lock" pointer
> +        * may only be set non-NULL if the "want" ticket is correct.
> +        * If we're updating "want", we must first clear "lock".
> +        */
> +       w->lock = NULL; 

I mean, I don't much care about Xen code, but that's two different
comment styles.
