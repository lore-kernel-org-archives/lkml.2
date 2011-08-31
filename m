Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1HaTtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 15:49:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44921 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab1HaTtm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 15:49:42 -0400
MIME-Version: 1.0
In-Reply-To: <1397886.AAh13B9r2H@wuerfel>
References: <4E582577.2060805@zytor.com>
	<201108311839.52863.arnd@arndb.de>
	<CA+55aFwVJ71=cLsUqMaJ-eGP0doPGBhrse9r++hkbiNYNx5Zjg@mail.gmail.com>
	<1397886.AAh13B9r2H@wuerfel>
Date: Wed, 31 Aug 2011 21:49:41 +0200
X-Google-Sender-Auth: Xn6KFRrgIg45W-gy0FGDbamO8CU
Message-ID: <CAMuHMdXC70gEX3USXaS17F__OLhvcQunHEFr0bYSq3=uR1GTKg@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 21:18, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 31 August 2011 09:48:35 Linus Torvalds wrote:
>> On Wed, Aug 31, 2011 at 9:39 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >
>> > Well, we could chicken out and just use unsigned int for time_t on new
>> > 32 bit ABIs, which would buy us time until ~2106 before we need to
>> > convert everything to 64 bit...
>>
>> You do realize that there are probably quite a lot of programs that
>> depend on signed time_t because they really do care about dates before
>> 1970?
>
> Yes, it already occurred to me after I had written the above that we
> really want it to be signed, especially to allow a meaningful conversion
> at least one-way between 32 and 64 bit time_t values.

If you care about dates before 1970, you're using time_t not to store
the current
time +/- some epsilon, for a "reasonable small epsilon", but to store real
dates. That was never a good idea. During the early days of UNIX, when the 1970
base was chosen, lots of people born before 1902 were still alive...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
