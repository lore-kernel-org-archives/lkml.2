Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab1CYQ34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:29:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751417Ab1CYQ3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:29:55 -0400
MIME-Version: 1.0
In-Reply-To: <4D8C772202000078000384E1@vpn.id2.novell.com>
References: <201103241026.01624.knikanth@suse.de> <20110324085647.GI30812@elte.hu>
 <20110324145221.GC31194@aftab> <4D8B83DA02000078000381DE@vpn.id2.novell.com>
 <20110324171924.GC2414@elte.hu> <4D8C772202000078000384E1@vpn.id2.novell.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Mar 2011 09:29:34 -0700
Message-ID: <AANLkTimXLAV-xssvuKMs8ZqUKsRgHDedjTiGM6fxQ-ku@mail.gmail.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock
 if possible
To: Jan Beulich <JBeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
        Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 3:06 AM, Jan Beulich <JBeulich@novell.com> wrote:
>
> The problem was observed with __lock_page() (in a variant not
> upstream for reasons not known to me), and prefixing e.g.
> trylock_page() with an extra PageLocked() check yielded the
> below quoted improvements.

Ok. __lock_page() _definitely_ should do the test_bit() thing first,
because it's normally called from lock_page() that has already tested
the bit.

But it already seems to do that, so I'm wondering what your variant is.

I'm also a bit surprised that lock_page() is that hot (unless your
_lock_page() variant is simply too broken and ends up spinning?).
Maybe we have some path that takes the page lock unnecessarily? What's
the load?

                Linus
