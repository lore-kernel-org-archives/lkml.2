Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab1GFUmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 16:42:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63877 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab1GFUmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 16:42:10 -0400
Date: Wed, 6 Jul 2011 22:42:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] x86,64: Simplify save_regs()
Message-ID: <20110706204201.GA19985@somewhere>
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
 <1309624184-9790-4-git-send-email-fweisbec@gmail.com>
 <4E1185F3020000780004BF21@nat28.tlf.novell.com>
 <20110704125742.GB1915@somewhere.redhat.com>
 <m2sjqj71ot.fsf@firstfloor.org>
 <4E14A781.8090004@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E14A781.8090004@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 11:20:49AM -0700, H. Peter Anvin wrote:
> On 07/06/2011 10:34 AM, Andi Kleen wrote:
> > Frederic Weisbecker <fweisbec@gmail.com> writes:
> >>
> >> I really did not think about code duplication, considering
> >> it's better to optimize the irq entry path.
> >>
> >> What do you guys think? We can still revert the whole patchset.
> > 
> > FWIW I think it should be a macro, like it was in the original code.
> > 
> > Optimizing entry*.S for code size doesn't make a lot of sense.
> > 
> 
> Code size, no.
> 
> *Path* size and cache/prefetch friendliness is another matter.
> The subroutine is bad on that account, too, so yes, this really seems
> like a losing proposition.
> 
> I'm not too fond of the gajillion obtuse macros we have, but subroutines
> doesn't make it really any better.

Fine, so I guess we can keep that macro conversion.
