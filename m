Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab2LMEbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 23:31:35 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35080 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab2LMEbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 23:31:34 -0500
Message-ID: <50C95A21.1010101@gmail.com>
Date: Wed, 12 Dec 2012 21:31:29 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.8
References: <20121211090910.GA22985@gmail.com> <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com> <50C94A9C.2050900@gmail.com> <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com> <50C94ECD.6020504@gmail.com> <CA+55aFzmsEbKCg=Qp0LGxQb-D+ZfBAELEa4HyUkuxkj6Z0-agA@mail.gmail.com>
In-Reply-To: <CA+55aFzmsEbKCg=Qp0LGxQb-D+ZfBAELEa4HyUkuxkj6Z0-agA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/12 8:51 PM, Linus Torvalds wrote:
> SO WHY DON'T YOU JUST DO THAT THEN?
>
> Disable PEBS on Vt-x enter and re-enable it on exit. End of story.
> Exactly like you say.

See commit 26a4f3c0. But that was not enough. Requiring exclude_guest 
was another required piece. If you want to see the discussion: 
https://lkml.org/lkml/2012/7/9/264

>
> But doing it this way was wrong. Switch that "exclude_guest" attribute
> around, and admit that "H" was bogus, and that the right thing to do
> was to add a "V" flag that sets the "force_guest" flag instead.

I understand this is annoying. Older binaries on newer kernels was the 
only case I could not fix. (I guess a message could be added kernel side 
to at least give a hint.) But the alternative -- based on code that has 
existed for some time -- is for older binaries to crash VMs.

David

