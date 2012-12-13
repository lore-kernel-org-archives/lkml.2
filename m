Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab2LMRDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 12:03:15 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:37606 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2LMRDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 12:03:13 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyZ2kAQPmZSv_sfHDAR1gusOxO22TRX-kqSim-cZrMscw@mail.gmail.com>
References: <20121211090910.GA22985@gmail.com> <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com>
 <50C94A9C.2050900@gmail.com> <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com>
 <50C94ECD.6020504@gmail.com> <CA+55aFzmsEbKCg=Qp0LGxQb-D+ZfBAELEa4HyUkuxkj6Z0-agA@mail.gmail.com>
 <50C95A21.1010101@gmail.com> <20121213073056.GA13156@gmail.com>
 <50C9E692.9070506@gmail.com> <CA+55aFzmDooC3tYzvP1YGv9g4ej1hBUQBPV6R+ukrfxuEELBaQ@mail.gmail.com>
 <50CA0134.2090608@gmail.com> <CA+55aFyZ2kAQPmZSv_sfHDAR1gusOxO22TRX-kqSim-cZrMscw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Dec 2012 09:02:50 -0800
X-Google-Sender-Auth: DWBJ3ZGnpe76VW24WQLUCtH_-ZI
Message-ID: <CA+55aFwSYyoLmdDJ5xsdwcWLThYQ7oieoeWDV2g+wV3CJk4vtg@mail.gmail.com>
Subject: Re: [GIT PULL] perf changes for v3.8
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, I do *not* think that you should necessariyl default to 'H' for
host-only mode.

The way it should work is that ":pp", ":ppH" and ":ppV" are all different.

 - "cycles:ppH" means: I want precise cycles only for the host case

 - "cycles:ppV" means: I want precise cycles, and I want the VM too

   This would result in EOPNOTSUPP for the case we know is buggy (but
presumably work on some other CPUs that don't have the problem)

 - "cycles:pp" is "I want precise cycles, and I don't care about virtualization"

   This would do whatever works. So it would basically become
host-only, but if you don't want precise cycles (so no ":pp") then
whatever our old behavior was (presumably "profile the virtual machine
too") would be what happens.

That sounds like (a) the interface that people want and (b) entirely
backwards-compatible for all cases that can matter (where "oops, I
crashed the VM" case does not matter).

                Linus
