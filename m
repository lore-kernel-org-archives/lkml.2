Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762414Ab2EQW4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:56:44 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59360 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927Ab2EQW4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:56:42 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzztct_HzmGiit=9SwwM4_YPuXbjwMdJpM1JHMXGBNqaA@mail.gmail.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
 <1337292816-10839-2-git-send-email-hjl.tools@gmail.com> <CA+55aFx98qvVg1JhMV0JjgNGb++xtir5ocseY3xgQNc3qAtWdQ@mail.gmail.com>
 <4FB57EB2.4050208@zytor.com> <CA+55aFzztct_HzmGiit=9SwwM4_YPuXbjwMdJpM1JHMXGBNqaA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 May 2012 15:56:21 -0700
X-Google-Sender-Auth: QuuKmPxNVXbA_oPrxsJ5Mqtvyig
Message-ID: <CA+55aFxAY5FvJOjr9=W=g7WDj_gNwKrEeCFAiY2L2YmpaDx1cw@mail.gmail.com>
Subject: Re: [PATCH 01/10] Use __kernel_long_t in struct timex
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 3:50 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I think __word would be good too, *except* for the fact that
> especially in x86 land, I think there's the legacy confusion with
> "word" being 16-bit. Ugh.

Looking at the x32 case, I have to say that "long" in general looks
horrible. Especially when we have things like

  typedef long long __kernel_long_t;

(and __long really wouldn't look any nicer). Any sane person would go
"Eww" at looking at that - we're using 'long long' to typedef a type
that is named 'long'.

It would make much more sense to use "__word" for reasons like that.
But I really don't think that works well in a x86 context.

Other ideas? Maybe "__wordsize" would be less associated with x86 16-bit words?

                 Linus
