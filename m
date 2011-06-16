Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab1FPHPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:15:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:46538 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab1FPHPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:15:19 -0400
Subject: Re: Oops in VMA code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Graf <agraf@suse.de>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTimB5gEZ2S=b9EiiWR-_u+o+wEPyjw@mail.gmail.com>
References: <47FAB15C-B113-40FD-9CE0-49566AACC0DF@suse.de>
	 <BANLkTimubRW2Az2MmRbgV+iTB+s6UEF5-w@mail.gmail.com>
	 <CDE289EC-7844-48E1-BB6A-6230ADAF6B7C@suse.de>
	 <BANLkTikLLfJ6yGNVcZ+o1RFmRoqRVrRSYQ@mail.gmail.com>
	 <96D27CEC-8492-49F2-913F-F587DEC5E95E@suse.de>
	 <BANLkTimB5gEZ2S=b9EiiWR-_u+o+wEPyjw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jun 2011 17:14:36 +1000
Message-ID: <1308208476.2516.67.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-15 at 23:54 -0700, Linus Torvalds wrote:
> On Wed, Jun 15, 2011 at 11:20 PM, Alexander Graf <agraf@suse.de> wrote:
> >
> > On 16.06.2011, at 07:59, Linus Torvalds wrote:
> >>
> >> r26 has the value 0xc00090026236bbb0, and that "90" byte in the middle
> >> there looks bogus. It's not a valid pointer any more, but if that "9"
> >> had been a zero, it would have been.
> >
> > Please see my reply to Ben here.
> 
> Your reply to Ben seems to say that 0xc00000026236bbb0 wouldn't have
> been a valid address, because you don't have that much memory.
> 
> But that's clearly not true. All the other registers have valid
> pointers in them, and the stack pointer (r1) is c000000262987cd0, for
> example. And that stack is clearly valid - if the kernel stack pointer
> was corrupted, you'd never have gotten as far as reporting the oops.
> 
> So you may have only 8GB of RAM in that machine, but if so, there's
> some empty unmapped physical space. Because clearly your RAM is _not_
> limited to being mapped to below 0xc000000200000000.

Right. It's a G5, RAM goes from 0...2G and 2G onward, with an IO hole
from 2 to 4G.

Cheers,
Ben.


