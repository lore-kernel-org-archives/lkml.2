Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab2DNVSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 17:18:16 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45118 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab2DNVSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 17:18:15 -0400
MIME-Version: 1.0
In-Reply-To: <1334441685-4438-4-git-send-email-levinsasha928@gmail.com>
References: <1334441685-4438-1-git-send-email-levinsasha928@gmail.com> <1334441685-4438-4-git-send-email-levinsasha928@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Apr 2012 14:17:53 -0700
X-Google-Sender-Auth: FzZaMYsIjKAO3JeraO1KdfFjTOI
Message-ID: <CA+55aFxDXPUCvP4CUWcz7aCNPkgTm1whDXh5GxJd4v-DcGPX2g@mail.gmail.com>
Subject: Re: [RFC 3/3] kernel.h: use new typechecking macros in min()/max()
 and friends
To: Sasha Levin <levinsasha928@gmail.com>
Cc: akpm@linux-foundation.org, peterz@infradead.org, mingo@elte.hu,
        hpa@zytor.com, tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 3:14 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> Convert to using new typechecking macros in kernel.h. This prevents code
> duplication and makes the modified macros (easily) readable again.
>
>  #define min(x, y) ({                           \
> -       typeof(x) _min1 = (x);                  \
> -       typeof(y) _min2 = (y);                  \
> -       (void) (&_min1 == &_min2);              \
> -       _min1 < _min2 ? _min1 : _min2; })
> +       typecmp2((x), (y));                             \
> +       (x) < (y) ? (x) : (y); })

They may be readable, but they are total shit.

You now evaluate 'x' and 'y' multiple times, so if they are function
calls or contain other side effects (like "a++" etc), you get the
wrong result.

So no. Hell no.

                  Linus
