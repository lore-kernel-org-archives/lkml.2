Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab1E0Pni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:43:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316Ab1E0Png (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:43:36 -0400
MIME-Version: 1.0
In-Reply-To: <201105270018.36835.rjw@sisk.pl>
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 May 2011 08:42:42 -0700
Message-ID: <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 3:18 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Well, as far as I can tell, this feature is going to break hibernation on
> both x86_32 and x86_64 at the moment, unless you can guarantee that the
> randomized kernel location will be the same for both the boot and the target
> kernels.

You know what? Maybe that guarantee is actually the *right* thing to do..

In other words, maybe we really really shouldn't randomize the kernel
load address at boot time at all.

Instead, what would be much better, is if we just had some way to
re-link distro kernels with some random text offset. Sure, the load
address wouldn't be "random" in any local sense any more, but I think
the real effort here was to avoid having the common distro kernels
having known text addresses.

If you compile your own kernel version, you're already home free, and
load-time randomization is pointless.

And load-time randomization has all these nasty problems with memory
maps etc, because we obviously have to shift the whole kernel around
by some fixed offset. But if there was some way to just re-link the
distro kernel easily, then it could be done by the kernel install
scripts, and it could potentially do more than just "shift up load
address by some random number".

Hmm?

                          Linus
