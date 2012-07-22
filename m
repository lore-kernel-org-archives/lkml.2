Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2GVTL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 15:11:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40572 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab2GVTLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 15:11:25 -0400
Date: Sun, 22 Jul 2012 21:11:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Cliff Wickman <cpw@sgi.com>,
        Jack Steiner <steiner@sgi.com>
Subject: Re: [GIT PULL] x86/uv changes for v3.6
Message-ID: <20120722191120.GA10328@gmail.com>
References: <20120722141523.GA8892@gmail.com>
 <CA+55aFyh9+ZGjP+3kP1_bqmSVLxsHvWP967ZnEFHuda1MhAZ8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyh9+ZGjP+3kP1_bqmSVLxsHvWP967ZnEFHuda1MhAZ8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, Jul 22, 2012 at 7:15 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > UV2 BAU productization fixes.
> 
> These kinds of "explanations" are not helpful, Ingo. Nobody 
> except the SGI people know what the hell those TLA's mean. So 
> please don't use random TLA's to "explain" things.

Sorry!

The Broadcast Assist Unit is SGI's fancy out of line way on UV 
hardware to do TLB flushes, instead of the normal APIC IPI 
methods. The commits here fix / work around hangs in their 
latest hardware iteration (UV2).

My understanding is that the main purpose of the out of line 
signalling channel is to improve scalability: the UV APIC 
hardware glue does not handle broadcasting to many CPUs very 
well, and this matters most for TLB shootdowns.

[ I don't agree with all aspects of the current approach: in 
  hindsight it would have been better to link the BAU at the 
  IPI/APIC driver level instead of the TLB shootdown level, 
  where TLB flushes are really just one of the uses of broadcast
  SMP messages. Doing that would improve scalability in some 
  other ways and it would also remove a few uglies from the TLB 
  path. It would also be nice to push more is_uv_system() tests 
  into proper x86_init or x86_platform callbacks. Cliff? ]

Thanks,

	Ingo
