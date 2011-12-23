Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab1LWJbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 04:31:36 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:32980 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1LWJbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 04:31:33 -0500
MIME-Version: 1.0
In-Reply-To: <8739cbkgv2.fsf@rustcorp.com.au>
References: <8739cbkgv2.fsf@rustcorp.com.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Dec 2011 01:31:12 -0800
X-Google-Sender-Auth: BXLfAWHJAqrnsmJvUuu4wXBKDMM
Message-ID: <CA+55aFyvMkAtXPRxiFR+UpZKGHMhp8Vd9aYg1dkaoKMwD5MLcw@mail.gmail.com>
Subject: Re: [RESENDx2] [PULL] virtio: fix barriers for virtio-mmio
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 9:16 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> This one as a signed tag on github, in case the inline patch was
> the reason you dropped this.

No, and please why do you make your tag-names be your email address?
That's just odd. It seems to be related to some broken SCM system that
thinks that tag-names are global and somehow different from
branch-names.

No, the reason I didn't pull was that the games with the barriers just
threw me off. They seem hacky and disgusting beyond words. And afaik
there are no actual *devices* that implement virtio-mmu, and the
commit that adds the mmu thing talks about qemu interfaces to. So it's
still just virtual, which makes the whole thing just masturbatory,
afaik. There's nothing out-of-order in virtual mmio.

So the whole thing looks confused. There's never any reason to
actually use the expensive sfence/rfences at all. Afaik you still just
want smp_*mb() for all cases.

                  Linus
