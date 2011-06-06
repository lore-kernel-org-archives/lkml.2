Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab1FFUvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:51:49 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:58407 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab1FFUvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=nvSgQpH0Cw1F2MwrN8OTyUHdbUHHkmbcsRAJwS0xVjXdT/q/fSznJT+3SBeGO8kPoi
         GBFlMN+qVJuypeww7iO/dFCPbKIgJRpv2uFFxnW5CV78Bhs93FoSVesEfHiHBsMqZKBW
         D7uf+W9FVQGT5/li9XRW6gW3yOzJXbeOBxoNs=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=choqfXPYmnivznYBbEFeg2UfbuA@mail.gmail.com>
References: <cover.1307292171.git.luto@mit.edu> <4DECAE68.16683.1203EBBB@pageexec.freemail.hu>
 <BANLkTin5jEmUUxWUUkYn9pKzGRwcA-zRLw@mail.gmail.com> <4DED206E.20356.13C155EA@pageexec.freemail.hu>
 <BANLkTi=choqfXPYmnivznYBbEFeg2UfbuA@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 6 Jun 2011 16:51:24 -0400
X-Google-Sender-Auth: JBtV3-rYJf6jc70U-33BgpHrNms
Message-ID: <BANLkTim8mSoifxoN=b2Gpe+WLjJyuqBR8g@mail.gmail.com>
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: pageexec@freemail.hu, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 4:40 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> We *definitely* don't want to name it in a way that makes some random
> person just turn it off because it's scary, since the random person
> *shouldn't* turn it off today. Comprende?

Yes, and fixed in the cleaned up version.

>
> And the annoying part about the whole patch series is how the whole
> re-sending has gone on forever.

If I have the patch-resending protocol wrong, please enlighten me.
I'm not sure how to make future work less annoying.

> Just pick some approach, do it, and
> don't even bother making it a config option for now. If we can replace
> the vsyscall page with a page fault or int3 or whatever, and it's only
> used for the 'time()' system call, just do it.

Really?

I won't personally complain about the 200+ ns hit, but I'm sure
someone will cc: me on a regression report if there's no option.

>
> The series is now extended with the cleanup patches so the end result
> looks reasonable, but why have the whole "first implement it, then
> clean it up" and sending it as a whole series. That's annoying. Just
> send the cleaned-up end result to begin with.

--Andy
