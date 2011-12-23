Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab1LWJft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 04:35:49 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55843 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab1LWJfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 04:35:47 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyvMkAtXPRxiFR+UpZKGHMhp8Vd9aYg1dkaoKMwD5MLcw@mail.gmail.com>
References: <8739cbkgv2.fsf@rustcorp.com.au> <CA+55aFyvMkAtXPRxiFR+UpZKGHMhp8Vd9aYg1dkaoKMwD5MLcw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Dec 2011 01:35:26 -0800
X-Google-Sender-Auth: SpiFqwONXAXGo5bawnXSoKOQL-8
Message-ID: <CA+55aFzKU0GWqpQo2AzAawoVm=qPaJiwKTcifeYApyZP_Hj3nQ@mail.gmail.com>
Subject: Re: [RESENDx2] [PULL] virtio: fix barriers for virtio-mmio
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 1:31 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So the whole thing looks confused. There's never any reason to
> actually use the expensive sfence/rfences at all. Afaik you still just
> want smp_*mb() for all cases.

But note that I haven't thought deeply about it, I just looked at the
patch and went "Hmm, that can't be right", and then it kind of got
dropped because I forgot about it.

On x86, there really is never any reason to use the heavy memory
barriers unless you are talking to a real device. And last I saw,
"virtio" was still about virtual IO.

Now, I could in theory imagine that you migth want to unconditionally
have the "smp_*mb()" barriers in the case where you are running UP
guest in an SMP host, but that's not what the patch actually did. It
did that odd crazy dynamic "IO barrier or SMP barrier" thing, which
just is confused and doesn't make sense to me in any situation I can
think of.

                    Linus
