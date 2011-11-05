Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1KEWii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 18:38:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57831 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1KEWih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 18:38:37 -0400
MIME-Version: 1.0
In-Reply-To: <1320529182.14081.78.camel@deneb.redhat.com>
References: <1320179267.14825.107.camel@deneb.redhat.com> <CA+55aFxXVwX6Y8Nw+V6k0niZ==fxAGfE=-FDYz8nCV4Pw9HEyw@mail.gmail.com>
 <1320529182.14081.78.camel@deneb.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 5 Nov 2011 15:38:15 -0700
X-Google-Sender-Auth: FVztXzXG16XEKJpJ6ftdfXOV2ic
Message-ID: <CA+55aFyypNAZAk0LQU7pFf+W2+6sdZwqQx5X8DLy0gWbfvjVsw@mail.gmail.com>
Subject: Re: [PULL] Add support for Texas Instruments C6X architecture
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 5, 2011 at 2:39 PM, Mark Salter <msalter@redhat.com> wrote:
>
> Okay, first of all, it doesn't break any old ones. There is one arch
> that currently uses asm-generic/page.h (blackfin) and that one uses a
> PAGE_OFFSET of 0x0 and has physical RAM starting at 0x0. My patch (wrong
> as it may otherwise be) won't break blackfin.

Ok. And I didn't notice that when you added the PFN_OFFSET, you did
actually remove the subtraction of PAGE_OFFSET from the
virtual->physical translation.

But I don't really understand why you did that. It makes very little sense.

> Are you saying that PAGE_OFFSET should always be zero in the NOMMU case?
> Or that ARCH_PFN_OFFSET shouldn't use PAGE_OFFSET (five existing arches
> use that same definition)?

So If the memory is mapped at some non-zero offset, what would make
*sense* to me is have the old

   #define __pa(x) ((unsigned long)(x) -- PAGE_OFFSET)

and that should already make sure that then the PFN is in the right
range, and doesn't need any fixups.

That's what the old version of the file did, and that seems to be a
sensible model. Why isn't it?

                      Linus
