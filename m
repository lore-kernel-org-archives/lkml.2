Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab2EUSG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:06:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57815 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758611Ab2EURhp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:37:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120521.050300.1434374935904126254.davem@davemloft.net>
References: <20120521.050300.1434374935904126254.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 May 2012 10:37:23 -0700
X-Google-Sender-Auth: 59uSu-K5hbqjRiXzPq67hY-j6Ts
Message-ID: <CA+55aFzag=LfduvHSmE34nEVYOk=MRhUMzK854+icLwthmz5Ng@mail.gmail.com>
Subject: Re: [GIT] Sparc
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 2:03 AM, David Miller <davem@davemloft.net> wrote:
>
> There is going to be a merge conflict between the commit in the
> net-next tree that adds the Sparc BPF JIT, and the one in here which
> adds arch/sparc/Kbuild.  It should be quite easy to resolve.

Ok, so that had a very obvious resolution, and a "cleaner, but scarier" version.

I picked the cleaner but scarier one - the one that should make the
BFP JIT be built when you do "make arch/sparc" by putting the net
thing into the new arch/sparc/Kbuild file.

I did minimal testing with "make ARCH=sparc" without actually
*building* anything, and in the process also fixed the fact that you
should not select HAVE_BPF_JIT unless networking is enabled (crappy
interface - maybe that "if NET" part really should be in the
HAVE_BPF_JIT rules, not in all the architectures?)

But I do not have (nor do I really want) a sparc cross-compile
environment, so maybe my "cleaner" resolution is just garbage. Can you
please check the end result?

So if I broke something, please call me names and tell me to not try
to think too much, and worry my little brain with things I don't
understand.

The thing is pushed out, so you can see what I did.

                    Linus
