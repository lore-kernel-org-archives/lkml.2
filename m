Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1IBU2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 16:28:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755268Ab1IBU2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 16:28:45 -0400
MIME-Version: 1.0
In-Reply-To: <4E61377B.4020600@goop.org>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
 <CA+55aFxpz+1bXVsg7kMeozePa=j_2-OaOuidQ4Y9Bg063=HMfg@mail.gmail.com> <4E61377B.4020600@goop.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Sep 2011 13:27:44 -0700
Message-ID: <CA+55aFy8p5-q9cNfyWz1bFT4RKxZosyHM2t5g2miiWm2DvP1Gg@mail.gmail.com>
Subject: Re: [PATCH 00/13] [PATCH RFC] Paravirtualized ticketlocks
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 2, 2011 at 1:07 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
> I don't know whether that fastpath code is small enough to consider
> inlining everywhere?

No.

There's no point in inlining something that ends up containing a
conditional function call: gcc will have to effectively save/restore
registers around that thing anyway, so you lose a lot of the
advantages of inlining. So I think it's better done as an out-of-line
function, which I thought we did for spinlocks anyway.

Also, do you run with CONFIG_OPTIMIZE_SIZE? Without that, gcc should
be smart enough to make a "likely()" case be a fall-through.

                          Linus
