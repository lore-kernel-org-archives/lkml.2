Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2BUEwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 23:52:45 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37912 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666Ab2BUEwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 23:52:44 -0500
X-Sasl-enc: BPvLOfDEcAoxvd4O/yyNdQvVYAPOqhfyV9/43Th9ytIB5dUj0WQQrCKx4A 1329799963
Message-ID: <1329799959.2226.32.camel@perseus.themaw.net>
Subject: Re: Linux 3.3-rc4
From: Ian Kent <raven@themaw.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 21 Feb 2012 12:52:39 +0800
In-Reply-To: <CA+55aFzVyr_U0-2Df2bqcX7G6DvkEGp=1N+ck4=EHuq=NY0Wkw@mail.gmail.com>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
	 <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de>
	 <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>
	 <20120219.144947.660678318380307878.davem@davemloft.net>
	 <CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com>
	 <1329794974.2226.11.camel@perseus.themaw.net>
	 <CA+55aFxDXcgOHRk5aPV5aGEDT3chXgcq_ktHKutk7OcyRjDUUw@mail.gmail.com>
	 <1329796956.2226.20.camel@perseus.themaw.net>
	 <CA+55aFzVyr_U0-2Df2bqcX7G6DvkEGp=1N+ck4=EHuq=NY0Wkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 20:17 -0800, Linus Torvalds wrote:
> On Mon, Feb 20, 2012 at 8:02 PM, Ian Kent <raven@themaw.net> wrote:
> >
> > It doesn't but changing it for exiting binaries will break existing
> > binaries that use a workaround.
> 
> What existing binaries?

My bad, autofs for one, but obviously when running in compat mode.
And any other user space users, such as the auto_dir package, but I
don't know if that is maintained any more.

> 
> > I'm proposing this because the systemd folks were happy to do it this
> > way. But if you would like any other existing user space users to change
> > to using a correctly sized packet then, yes, it isn't what you want to
> > happen.
> 
> Existing binaries *do* use the correct size packet - it's the correct
> size for native x86-32!
> 
> It's our x86-64 compat layer that is wrong. It's a clear bug. Nothing else.
> 
> We don't start making up new interfaces because we have clear bugs: we
> fix the damn bugs.
> 
> How could you even sanely do "workarounds"? A x86-32 binary shouldn't
> even be able to *tell* that the kernel is 64-bit. And if it does that
> somehow, we should fix that too!

Sure, not an acceptable excuse I know, but it was too late when I
realized my mistake.

So, as you say, let's fix the bug.

autofs is by far the biggest user and I can manage the change for it and
I can at least post to the auto_dir list (if it still exists) and Thomas
can feedback to the systemd folks.

Then there is the question of how it should be done.

I think the patch attached to your original post needs a little work if
that is to be used. Correct me if I'm wrong but AFAICT there are more
architectures that use 8-byte alignment than just x86-64, such as alpha,
ia64 and ppc64 and I believe they may also be used in a compat mode.

Is there a better way to do this change, anyone?

Ian

