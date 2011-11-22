Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab1KVEgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 23:36:00 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59701 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab1KVEf6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 23:35:58 -0500
MIME-Version: 1.0
In-Reply-To: <1321925466-11280-2-git-send-email-ddaney.cavm@gmail.com>
References: <1321925466-11280-1-git-send-email-ddaney.cavm@gmail.com> <1321925466-11280-2-git-send-email-ddaney.cavm@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Nov 2011 20:35:36 -0800
X-Google-Sender-Auth: fBzjI15892Z_m9fgC7sDXRvQFqA
Message-ID: <CA+55aFwj1eajCY2cF-xBzUqfnoZz+u1EGzWUsJBDnjWes3qj8g@mail.gmail.com>
Subject: Re: [PATCH 1/2] kernel.h: Add BUILD_BUG_ON_USED() macro.
To: David Daney <ddaney.cavm@gmail.com>
Cc: ralf@linux-mips.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 5:31 PM, David Daney <ddaney.cavm@gmail.com> wrote:
>
> The GCC function attribute error("message") was added in version 4.3,
> so we define a new macro __linktime_error(message) to expand to this
> for GCC-4.3 and later.  This will give us an error diagnostic from the
> compiler on the line that fails.  For other compilers
> __linktime_error(message) expands to nothing, and we have to be
> content with a link time error, but at least we will still get a build
> error.

Ok. This looks quite reasonable, and I suspect we could replace some
of the other cases that currently use link-time errors with this and
get slightly better error reporting. It also looks like we should use
this __attribute__((__error__())) approach for our current
BUILD_BUG_ON() thing, instead of playing with the whole "negative
array size" thing.

And it does seem like glibc already uses this thing heavily, so we can
even expect it to work.

That said, I'm still not comfy actually applying these patches during
the -rc series. But for the next merge window, no problem.

                      Linus
