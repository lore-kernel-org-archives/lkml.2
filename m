Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab2CODs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 23:48:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54244 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab2CODs5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 23:48:57 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1203150056361.2466@ionos>
References: <20120302164234.4938.38390934@jp.panasonic.com>
 <20120314144601.ccc50a68.akpm@linux-foundation.org> <alpine.LFD.2.02.1203142250500.2466@ionos>
 <alpine.LFD.2.02.1203150056361.2466@ionos>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 14 Mar 2012 20:48:36 -0700
X-Google-Sender-Auth: o9w51IRMgLrQfjeOHiNzBUJz5Kc
Message-ID: <CA+55aFygRpuCZ0K0_hon7t3H+qa3WKb3--VXooN8p14S6or2tw@mail.gmail.com>
Subject: Re: [REGRESSION][PATCH] mqueue: Ignore the validity of abs_timeout
 parameter when message can be performed immediately
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        linux-kernel@vger.kernel.org, Carsten Emde <C.Emde@osadl.org>,
        Manfred Spraul <manfred@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 5:28 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Aside of my previous ranting about the insanity of that, the following
> is actually open for interpretation:
>
>  "The validity of the abstime parameter need not be checked if a
>  message can be removed from the message queue immediately."
>
> It's not necessary to check the validity of the abstime parameter, but
> the spec does not forbid it either.

Yeah, I have to agree with your reading.

I think that checking the validity is the sane thing to do, especially
if it just "falls out" of how the code is written.

At the same time, I can also imagine code that doesn't even look at
the timeout parameter unless it is about to go to sleep, so I can
understand the POSIX wording too: you don't *have* to check the
validity if it's irrelevant, and not checking it is the natural thing
for the code.

But it certainly doesn't seem to disallow the current code either.

So I do not think that the POSIX wording should be taken to mean that
"you mustn't check the validity". It's a "whatever", not a "must do
X".

With the current code, checking the validity of the timeout falls out
from what we do. I don't think we need to work around that, based on
the POSIX wording. And if there are no applications that actually
broke, I don't think we should care.

Is there some other standard that says that you *have* to let crazy
invalid values go?

                 Linus
