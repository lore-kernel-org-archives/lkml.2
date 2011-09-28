Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab1I1TGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 15:06:40 -0400
Received: from claw.goop.org ([74.207.240.146]:38843 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab1I1TGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 15:06:39 -0400
Message-ID: <4E83703C.2010907@goop.org>
Date: Wed, 28 Sep 2011 12:06:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <JBeulich@suse.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        the arch/x86 maintainers <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com> <4E835851.7070502@zytor.com> <4E835E50.2020307@goop.org> <201109282008.17722.stephan.diestelhorst@amd.com> <CA+55aFwm7ESNfrHhEHrAKcjcPUq8YxtuEkJd5PzAekYo2dMYNw@mail.gmail.com>
In-Reply-To: <CA+55aFwm7ESNfrHhEHrAKcjcPUq8YxtuEkJd5PzAekYo2dMYNw@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 11:49 AM, Linus Torvalds wrote:
> But I don't care all *that* deeply. I do agree that the xaddw trick is
> pretty tricky. I just happen to think that it's actually *less* tricky
> than "read the upper bits separately and depend on subtle ordering
> issues with another writer that happens at the same time on another
> CPU".
>
> So I can live with either form - as long as it works. I think it might
> be easier to argue that the xaddw is guaranteed to work, because all
> values at all points are unarguably atomic (yeah, we read the lower
> bits nonatomically, but as the owner of the lock we know that nobody
> else can write them).

Exactly.  I just did a locked add variant, and while the code looks a
little simpler, it definitely has more actual complexity to analyze.

    J
