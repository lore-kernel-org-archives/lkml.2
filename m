Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2LWAAY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 19:00:24 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36787 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2LWAAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 19:00:23 -0500
MIME-Version: 1.0
In-Reply-To: <50D6086E.4000402@gmail.com>
References: <50C94ECD.6020504@gmail.com> <CA+55aFzmsEbKCg=Qp0LGxQb-D+ZfBAELEa4HyUkuxkj6Z0-agA@mail.gmail.com>
 <50C95A21.1010101@gmail.com> <20121213073056.GA13156@gmail.com>
 <50C9E692.9070506@gmail.com> <CA+55aFzmDooC3tYzvP1YGv9g4ej1hBUQBPV6R+ukrfxuEELBaQ@mail.gmail.com>
 <50CA0134.2090608@gmail.com> <CA+55aFyZ2kAQPmZSv_sfHDAR1gusOxO22TRX-kqSim-cZrMscw@mail.gmail.com>
 <20121213165904.GA18574@gmail.com> <CA+55aFwfxRgLqSsa1=4KvhR6E5GdvfGGxTM_0++YepLv5A_U_w@mail.gmail.com>
 <20121213173101.GA19444@gmail.com> <50CEA2F7.7020908@gmail.com> <50D6086E.4000402@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 22 Dec 2012 16:00:00 -0800
X-Google-Sender-Auth: 91KJF2vPPgntr_4b8aKZ0-iqR9c
Message-ID: <CA+55aFzADpQTEGNDNVBpL9Ep8xD=9_1pViiZvFLb4KPzKpKNZQ@mail.gmail.com>
Subject: Re: [GIT PULL] perf changes for v3.8
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure. I actually think both should be deprecated, and replaced with
explicit "trace guest" vs "trace host" flags, just to make it
consistent, but I don't care deeply.

The only thing I care about is that compatibility must never be broken
(which the current setup does), and that people who don't use
virtualization should never be asked to use flags that have anything
to do with virtualization (which the current work-around involves).

        Linus

On Sat, Dec 22, 2012 at 11:22 AM, David Ahern <dsahern@gmail.com> wrote:
> any opinions on whether the approach is reasonable?
>
> On 12/16/12 9:43 PM, David Ahern wrote:
>>
>> All that is needed is for the current exclude_guest flag to be
>> deprecated such that for older binaries on newer kernels it is ignored
>> (perhaps a warn on once), and then a new flag -- exclude_guest2 -- is
>> then used for the new logic.
