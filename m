Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1HGSia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 14:38:30 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63390 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab1HGSi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 14:38:27 -0400
References: <1312595187-3265-1-git-send-email-msb@chromium.org> <CAGhQ9Vxb9F0jJ2o0ft-OOfOUMOArj_ci2gO__mxPkZJaNiA+4A@mail.gmail.com> <CA+55aFxKES2bbcYWD29TFsGg19KXauPDwdkgYXXZbZ72kEXduw@mail.gmail.com> <CAGhQ9VzBAXv1cW5hAmUmfHQBDcAprLg_8T2XxRyrWT2G85AV6A@mail.gmail.com> <CA+55aFyECSVQT9Gi6KuiBrrMoC44CVJRZAb+s0Lt9j0UuKyfwQ@mail.gmail.com> <CAGhQ9Vx-MoFb7rEBQCwqi8zLjoWiED7FXvzcq2eDfTEg_P=2ug@mail.gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CAGhQ9Vx-MoFb7rEBQCwqi8zLjoWiED7FXvzcq2eDfTEg_P=2ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] lib/sha1: use the git implementation of SHA-1
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 07 Aug 2011 11:38:12 -0700
To: Joachim Eastwood <manabian@gmail.com>
CC: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
        Nicolas Pitre <nico@cam.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux@arm.linux.org.uk
Message-ID: <d86cf41b-bc2f-400f-823e-8042913974ae@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There aren't many users of that define, could you just turn it back to the proper 16, and then try changing it to 80 in each place that uses it?

That way we'd see exactly *which* use is the buggy one..

        Linus

Joachim  Eastwood <manabian@gmail.com> wrote:

>On Sun, Aug 7, 2011 at 7:44 PM, Linus Torvalds
><torvalds@linux-foundation.org> wrote:
>> On Sun, Aug 7, 2011 at 10:36 AM, Joachim  Eastwood
><manabian@gmail.com> wrote:
>>>
>>> These printk's come from drivers/char/random.c
>>> So it doesn't seem like it hangs in any of the sha_* funtions.
>>
>> The only other change is to SHA_WORKSPACE_WORDS - I wonder if some
>> code depends on the old (much bigger) workspace for some reason?
>>
>> The git SHA1 routines are way smarter than the old SHA1, and will
>> re-use the workspace area, so they need only a fraction of the old
>> area.
>>
>> Try changing SHA_WORKSPACE_WORDS back to 80 (in
>> include/linux/cryptohash.h). The git sha1 only needs 16 words, but ..
>
>yup, setting it to 80 makes my kernel boot again :-)
>
>> If that fixes it for you, then it's almost certainly some buggy user
>> that uses the SHA1 workspace array for its own odd case, and
>> incorrectly "knows" that it's that old wasteful 320 bytes. There's a
>> few places in networking that uses SHA_WORKSPACE_WORDS.
>
>Guess more architectures than ARM are affected by this then.
>
>regards
>Joachim Eastwood
>
>>                                     Linus
>>

