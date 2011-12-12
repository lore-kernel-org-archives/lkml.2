Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab1LLXue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:50:34 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51385 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab1LLXuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:50:32 -0500
MIME-Version: 1.0
In-Reply-To: <1323712953-13636-1-git-send-email-dtor@vmware.com>
References: <1323712953-13636-1-git-send-email-dtor@vmware.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 12 Dec 2011 15:50:11 -0800
X-Google-Sender-Auth: axij8WEJHTsO3AFdRjO9Iz6J3lg
Message-ID: <CA+55aFyCaZ89wWEjFyiwJmGxfmTiR0ri7zjp0V=KeyvMo75etw@mail.gmail.com>
Subject: Re: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
To: Dmitry Torokhov <dtor@vmware.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        pv-drivers@vmware.com, Andrei Warkentin <andreiw@vmware.com>,
        stable@kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 10:02 AM, Dmitry Torokhov <dtor@vmware.com> wrote:
> From: Andrei Warkentin <andreiw@vmware.com>
>
> 1 is a power of two, therefore rounddown_pow_of_two(1) should return 1.
> It does in case the argument is a variable but in case it's a constant
> it behaves incorrectly and returns 0. Probably nobody ever did it so
> this was never noticed, however drivers/net/vmxnet3 with latest GCC does
> and breaks on unicpu systems.
>
> This is similar to Rolf's patch to roundup_pow_of_two(1).

Umm. I already applied this patch, but then I started looking at it
more, and asked myself:

 - Why is that "n == 1" test there AT ALL?

Afaik, that whole test is just plain stupid. It seems to have been
copied from the "roundup()" case (where it exists due to the "-1/+1"
hackery that breaks ilog2()) without any thought about the actual math
of the function at all.

I think the *real* fix is to just remove that incorrect line, no?

It's a bit sad that we apparently have several reviewers for this
trivial patch, and nobody reacted to the math just not making any
sense.

                                      Linus
