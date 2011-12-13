Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1LMGBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 01:01:33 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:29865 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380Ab1LMGBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 01:01:32 -0500
Date: Mon, 12 Dec 2011 22:01:31 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        pv-drivers@vmware.com, Andrei Warkentin <andreiw@vmware.com>,
        stable@kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
Message-ID: <20111213060131.GA3575@dtor-ws.eng.vmware.com>
References: <1323712953-13636-1-git-send-email-dtor@vmware.com>
 <CA+55aFyCaZ89wWEjFyiwJmGxfmTiR0ri7zjp0V=KeyvMo75etw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyCaZ89wWEjFyiwJmGxfmTiR0ri7zjp0V=KeyvMo75etw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 03:50:11PM -0800, Linus Torvalds wrote:
> On Mon, Dec 12, 2011 at 10:02 AM, Dmitry Torokhov <dtor@vmware.com> wrote:
> > From: Andrei Warkentin <andreiw@vmware.com>
> >
> > 1 is a power of two, therefore rounddown_pow_of_two(1) should return 1.
> > It does in case the argument is a variable but in case it's a constant
> > it behaves incorrectly and returns 0. Probably nobody ever did it so
> > this was never noticed, however drivers/net/vmxnet3 with latest GCC does
> > and breaks on unicpu systems.
> >
> > This is similar to Rolf's patch to roundup_pow_of_two(1).
> 
> Umm. I already applied this patch, but then I started looking at it
> more, and asked myself:
> 
>  - Why is that "n == 1" test there AT ALL?
> 
> Afaik, that whole test is just plain stupid. It seems to have been
> copied from the "roundup()" case (where it exists due to the "-1/+1"
> hackery that breaks ilog2()) without any thought about the actual math
> of the function at all.
> 
> I think the *real* fix is to just remove that incorrect line, no?

Yes, you are right, special-casing for 1 is not necessary in rounddown
case.

Thanks,
Dmitry

