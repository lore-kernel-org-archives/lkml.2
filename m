Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab2KFNFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:05:02 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62135 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2KFNFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:05:00 -0500
MIME-Version: 1.0
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7094@saturn3.aculab.com>
References: <1351957422-23243-1-git-send-email-akinobu.mita@gmail.com>
	<90816.1352178872@turing-police.cc.vt.edu>
	<AE90C24D6B3A694183C094C60CF0A2F6026B7094@saturn3.aculab.com>
Date: Tue, 6 Nov 2012 22:04:59 +0900
Message-ID: <CAC5umyh7cSiBaBLroNbAJoZ4_B1W9o+qLPGMtXj4Yqn7sTAaTw@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] introduce random32_get_bytes() and random32_get_bytes_state()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: David Laight <David.Laight@aculab.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Eilon Greenstein <eilong@broadcom.com>, netdev@vger.kernel.org,
        Robert Love <robert.w.love@intel.com>, devel@open-fcoe.org,
        Michel Lespinasse <walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/6 David Laight <David.Laight@aculab.com>:
>> On Sun, 04 Nov 2012 00:43:31 +0900, Akinobu Mita said:
>> > This patchset introduces new functions into random32 library for
>> > getting the requested number of pseudo-random bytes.
>> >
>> > Before introducing these new functions into random32 library,
>> > prandom32() and prandom32_seed() with "prandom32" prefix are
>> > renamed to random32_state() and srandom32_state() respectively.
>> >
>> > The purpose of this renaming is to prevent some kernel developers
>> > from assuming that prandom32() and random32() might imply that only
>> > prandom32() was the one using a pseudo-random number generator by
>> > prandom32's "p", and the result may be a very embarassing security
>> > exposure.
>>
>> Out of curiosity, why the '32'?  I'm just waiting for some kernel developer to
>> do something stupid with this on a 64-bit arch because they think it's a 32-bit API. ;)
>>
>> Should we bite the bullet and lose the 32, as long as we're churning the code *anyhow*?
>
> Also why remove the 'pseudo' part of the name?
> It is an important part of the name.

Thanks for the heads-up.  Then, what is the ideal function name for
pseudo-random library?

I propose the following renaming, 'p' prefix is restored and '32' is
removed for not returning 32bit pseudo-random number functions.

void prandom_seed(u32 seed);    /* rename from srandom32() */
u32 prandom32(void);            /* rename from random32() */
void prandom_get_byte(void *buf, int bytes);

void prandom_seed_state(struct rnd_state *state, u64 seed);
                                        /* rename from prandom32_seed() */
u32 prandom32_state(struct rnd_state *state);   /* rename from prandom32() */
void prandom_get_byte_state(struct rnd_state *state, void *buf, int bytes);
