Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1HXXMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 19:12:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948Ab1HXXMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 19:12:08 -0400
MIME-Version: 1.0
In-Reply-To: <4E558380.7060304@zytor.com>
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com>
 <738d736ecffa3bd32df76ae41188aa39c2ace941.1314054734.git.jeremy.fitzhardinge@citrix.com>
 <alpine.DEB.2.00.1108231355380.26421@router.home> <4E540548.4080402@goop.org>
 <4E541154.6090805@zytor.com> <4E542681.2090703@goop.org> <alpine.DEB.2.00.1108240852370.24118@router.home>
 <4E5527C2.8000801@goop.org> <alpine.DEB.2.00.1108241408310.30776@router.home>
 <4E555FBB.3020906@zytor.com> <4E556150.8030100@goop.org> <4E558380.7060304@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Aug 2011 16:11:13 -0700
Message-ID: <CA+55aFy9r7jHi_9B4zH9LEy4PidWvjs5nDddHA5RyKRvunDehA@mail.gmail.com>
Subject: Re: [PATCH 13/15] x86: add cmpxchg_flag() variant
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Christoph Lameter <cl@linux.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 4:04 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
>> I was also thinking that using it reduces register pressure, since you
>> don't need to keep the "old" value around, so it dies sooner.
>
> ... but you burn a register for the intermediate flag value, so you're
> just as bad off.

But that register has much shorter liveness - so I do agree that it *can* help.

Whether it actually *does* help is unclear. I do agree that we might
be better off without introducing yet another (questionable)
interface.

                     Linus
