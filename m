Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab1JSEdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:33:20 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:51151 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754037Ab1JSEdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:33:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAGhSnk55LI88/2dsb2JhbABEqHCBBoFuAQEFOhwjEAgDGC4UJQMhE71AEocoYQSlaQ
Date: Wed, 19 Oct 2011 15:33:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Russell King <rmk@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
Message-ID: <20111019043315.GE21338@dastard>
References: <4E9E0B71.9020708@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9E0B71.9020708@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 04:27:45PM -0700, Tim Bird wrote:
> I'm about to submit a set of patches (really pretty small)
> to add 4K stack support to ARM (defaulted to 'N').
> 
> This has been kicking around in my Sony tree for a few years,
> and it's about time to mainline it.  The first patch is
> the actual 4KSTACKS patch.  See subsequent patches
> for tools to help with stack reduction to avoid the problems
> that apparently led to the removal of this feature on x86.

Not this again. There's a good reason 4k stacks went away: it's
simply not enough space for the deep 60+ function call stacks we see
with even trivial storage stack configurations.

The stack usage on 32 bit ARM and x86 is going to be similar, so
you're going to be fighting a losing battle - there is no stack
space tha tcan be trimmed from most paths. To make matter worse,
there's been stuff done to the storage stack that significantly
increases stack usage since 4k stacks went away (e.g. the on-stack
block plugging changes).

And FWIW, XFS is widely used on ARM based NAS devices, so this isn't
a theoretical problem I'm making up here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
