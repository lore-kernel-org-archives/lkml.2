Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab1CXX1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 19:27:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757333Ab1CXX1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:27:49 -0400
MIME-Version: 1.0
In-Reply-To: <m2oc50kxg0.fsf@firstfloor.org>
References: <201103241026.01624.knikanth@suse.de> <20110324085647.GI30812@elte.hu>
 <20110324145221.GC31194@aftab> <4D8B83DA02000078000381DE@vpn.id2.novell.com>
 <20110324173020.GA26761@sgi.com> <20110324200010.GB7957@elte.hu>
 <1300999682.2714.23.camel@edumazet-laptop> <20110324205422.GB2393@elte.hu>
 <1301000557.2714.33.camel@edumazet-laptop> <m2oc50kxg0.fsf@firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Mar 2011 16:26:52 -0700
Message-ID: <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock
 if possible
To: Andi Kleen <andi@firstfloor.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jack Steiner <steiner@sgi.com>, Jan Beulich <JBeulich@novell.com>,
        Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 2:42 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> The "if anyone else uses the PMU throw in your toys and sulk" check was
> only recently added.

,, and I'd like to point out that we should just say "screw the
f*cking BIOS, it's doing things wrong". And then just take over the
PMU events, and make sure that they aren't routed to SCI. Instead of
the current "ok, roll over and die when the BIOS does something
idiotic".

People continuously claim that the BIOS really needs it, and I have
never EVER seen any good explanation of why that particular sh*t
argument would b true. It seems to be purely about politics, where
some idiotic vendor (namely HP) has convinced Intel that they really
need it. To the point where some engineers seem to have bought into
the whole thing and actually believe that fairy tale ("firmware can do
better" - hah! They must be feeding people some bad drugs at the
cafeteria)

                     Linus
