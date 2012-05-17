Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030482Ab2EQWcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:32:24 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46876 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967208Ab2EQWcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:32:22 -0400
MIME-Version: 1.0
In-Reply-To: <1337292816-10839-2-git-send-email-hjl.tools@gmail.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <1337292816-10839-2-git-send-email-hjl.tools@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 May 2012 15:32:00 -0700
X-Google-Sender-Auth: VNiAuWN_EzUiitpSTIHW97fyTFs
Message-ID: <CA+55aFx98qvVg1JhMV0JjgNGb++xtir5ocseY3xgQNc3qAtWdQ@mail.gmail.com>
Subject: Re: [PATCH 01/10] Use __kernel_long_t in struct timex
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 3:13 PM, H.J. Lu <hjl.tools@gmail.com> wrote:
>
> Replace long with __kernel_long_t in struct timex for user space.

I absolutely detest these types.

I realize that we already have a few users, but just looking at these
diffs *hurts*. It's disgusting.

The whole __kernel_ prefix was a mistake, but it at least makes sense
for certain things where it is really about some random kernel choice
(ie __kernel_pid_t). Even there I despise it, because it's not really
about "kernel choice", it's about just the real native type for uid_t
- the fact that user-mode then occasionally screwed up because glibc
has chosen crazy extended types is really not a "kernel" issue at all.
So the naming in general is painful.

When it comes to the x32 thing I think it's *doubly* wrong, because
this isn't even about a "kernel choice". It's damn well the native
machine word-size. The fact that a limited user-mode ABI then limits
"long" to 32-bit is not the kernels problem.

So I'd really like to see some discussion about naming. What does this
have to do with "kernel"? Nothing. It's the native word-size of the
machine, for crying out loud. The fact that some user interfaces may
limit themselves is not a "user mode vs kernel" thing.

                        Linus
