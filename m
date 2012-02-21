Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab2BUFjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 00:39:54 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54895 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800Ab2BUFjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 00:39:52 -0500
X-Sasl-enc: 1451ciGtOB4gxO3LvLPRIIWtcceqw3fvUL9XBB5Q4OSigjrTe8O4Pw6z1Q 1329802791
Message-ID: <1329802787.2226.33.camel@perseus.themaw.net>
Subject: Re: Linux 3.3-rc4
From: Ian Kent <raven@themaw.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 21 Feb 2012 13:39:47 +0800
In-Reply-To: <CA+55aFwBD7pbOcSUVguF+vFAs85JhNpjJgZtDKjEJA0PVXrhkw@mail.gmail.com>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
	 <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de>
	 <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>
	 <20120219.144947.660678318380307878.davem@davemloft.net>
	 <CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com>
	 <1329794974.2226.11.camel@perseus.themaw.net>
	 <CA+55aFxDXcgOHRk5aPV5aGEDT3chXgcq_ktHKutk7OcyRjDUUw@mail.gmail.com>
	 <1329796956.2226.20.camel@perseus.themaw.net>
	 <CA+55aFzVyr_U0-2Df2bqcX7G6DvkEGp=1N+ck4=EHuq=NY0Wkw@mail.gmail.com>
	 <1329799959.2226.32.camel@perseus.themaw.net>
	 <CA+55aFwBD7pbOcSUVguF+vFAs85JhNpjJgZtDKjEJA0PVXrhkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 21:06 -0800, Linus Torvalds wrote:
> On Mon, Feb 20, 2012 at 8:52 PM, Ian Kent <raven@themaw.net> wrote:
> >
> > I think the patch attached to your original post needs a little work if
> > that is to be used. Correct me if I'm wrong but AFAICT there are more
> > architectures that use 8-byte alignment than just x86-64, such as alpha,
> > ia64 and ppc64 and I believe they may also be used in a compat mode.
> 
> The only issue is compat mode, and afaik, all other architectures
> except for x86-32 do __u64 with natural alignment.
> 
> So all 64-bit architectures use natural alignment, the only issue is
> the alignment of __u64 in 32-bit mode.
> 
> So it really is *not* about 8-byte alignment. Quite the reverse. It's
> about 4-byte alignment of 64-bit entities, and I suspect x86-32 is the
> only one that does that.
> 
> See "compat_u64", and notice how only in arch/x86/include/asm/compat.h
> do we have
> 
>   typedef u64 __attribute__((aligned(4))) compat_u64;
> 
> So it really is limited to only x86.

Thanks, I wasn't aware of this.

> 
>                Linus


