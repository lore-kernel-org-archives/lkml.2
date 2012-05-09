Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab2EIE1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 00:27:35 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52198 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2EIE1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 00:27:34 -0400
MIME-Version: 1.0
In-Reply-To: <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
 <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 May 2012 21:27:12 -0700
X-Google-Sender-Auth: nMipMU1p5zmD6kFTGqNVa9j2I00
Message-ID: <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Kay Sievers <kay@vrfy.org>, Greg Kroah-Hartmann <greg@kroah.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 9:11 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>
> Is there a reason to keep KERN_CONT under this set of rules at all?

Yes, a very subtle and rare one.

If you want to print out a string that starts with "<%d>", you *have*
to use a prefix, in order to not make printk think that the "<*>" is
the prefix itself.

And if you don't want to start a new line, you need to use KERN_CONT.

So there is *one* case, and one case only, where KERN_CONT is useful,
and it's when the string you are printing out could otherwise be
mistaken for a prefix itself (the "<%d>" thing isn't the only such
string, of course - it could be a "%s" where the string has those
characters in it.

So think of KERN_CONT as a "quoting safety" thing. And in 99% of all
cases it is obviously not actually needed. So in general, KERN_CONT is
useless and should not be used, but that doesn't mean that it can be
removed as a _concept_.

               Linus
