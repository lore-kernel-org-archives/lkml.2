Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab2BUERz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 23:17:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48654 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2BUERy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 23:17:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.181.12.106 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <1329796956.2226.20.camel@perseus.themaw.net>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
 <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de> <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>
 <20120219.144947.660678318380307878.davem@davemloft.net> <CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com>
 <1329794974.2226.11.camel@perseus.themaw.net> <CA+55aFxDXcgOHRk5aPV5aGEDT3chXgcq_ktHKutk7OcyRjDUUw@mail.gmail.com>
 <1329796956.2226.20.camel@perseus.themaw.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Feb 2012 20:17:32 -0800
X-Google-Sender-Auth: o042KoYJamEVao7r5f94rFWyiRw
Message-ID: <CA+55aFzVyr_U0-2Df2bqcX7G6DvkEGp=1N+ck4=EHuq=NY0Wkw@mail.gmail.com>
Subject: Re: Linux 3.3-rc4
To: Ian Kent <raven@themaw.net>
Cc: David Miller <davem@davemloft.net>, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 8:02 PM, Ian Kent <raven@themaw.net> wrote:
>
> It doesn't but changing it for exiting binaries will break existing
> binaries that use a workaround.

What existing binaries?

> I'm proposing this because the systemd folks were happy to do it this
> way. But if you would like any other existing user space users to change
> to using a correctly sized packet then, yes, it isn't what you want to
> happen.

Existing binaries *do* use the correct size packet - it's the correct
size for native x86-32!

It's our x86-64 compat layer that is wrong. It's a clear bug. Nothing else.

We don't start making up new interfaces because we have clear bugs: we
fix the damn bugs.

How could you even sanely do "workarounds"? A x86-32 binary shouldn't
even be able to *tell* that the kernel is 64-bit. And if it does that
somehow, we should fix that too!

                       Linus
