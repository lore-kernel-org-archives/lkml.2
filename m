Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2LMDZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 22:25:24 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:33524 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab2LMDZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 22:25:23 -0500
Message-ID: <50C94A9C.2050900@gmail.com>
Date: Wed, 12 Dec 2012 20:25:16 -0700
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
References: <20121211090910.GA22985@gmail.com> <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com>
In-Reply-To: <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/12 7:53 PM, Linus Torvalds wrote:
> Hmm. This may be entirely unrelated to this particular pull request, but
>
>     perf record -e cycles:pp
>
> no longer works on my westmere machine (Operation not supported). It
> used to work, but I haven't tried to bisect it, since I hope somebody
> will just go "oh, I know what's up".

One last "I may know what's up" question. I wonder if you are tripping 
on this:

     if (event->attr.precise_ip) {
         int precise = 0;

         if (!event->attr.exclude_guest)
             return -EOPNOTSUPP;

Are you running an older perf binary on the 3.8 kernel?

Does this work: perf record -e cycles:ppH  ...

David
