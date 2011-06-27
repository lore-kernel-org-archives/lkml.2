Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab1F0J0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:26:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58126 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab1F0JZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:25:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EwLVgHh9AwJyLfrjCm9dyiXzjMMUsISSoOnUJjp+gs+GZsyk054B/EMSLUBiC37D8q
         NLmledTospPrKtf6MZwMbNHkAEifI7X/G5MDIA7oteShmNgM0/hpFQaoEdUDYcI76glj
         ZjSuieAwcfgn9xyzuWuIabHygsjbhYvOetmbM=
MIME-Version: 1.0
In-Reply-To: <87hb7b7ic6.fsf@rustcorp.com.au>
References: <1308987512-6583-1-git-send-email-jonas@southpole.se>
	<20110625100449.GA19097@elte.hu>
	<1308998367.6699.30.camel@localhost>
	<201106251508.50129.arnd@arndb.de>
	<87hb7b7ic6.fsf@rustcorp.com.au>
Date: Mon, 27 Jun 2011 11:25:23 +0200
X-Google-Sender-Auth: tSbossggz-wuCHwDufbVHrzpWOU
Message-ID: <BANLkTinmhQT=__WP+10cr2HZPy1TvdxZ=w@mail.gmail.com>
Subject: Re: [PATCH] modules: add default loader hook implementations
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonas Bonn <jonas@southpole.se>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, monstr@monstr.eu, cmetcalf@tilera.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 11:07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Sat, 25 Jun 2011 15:08:49 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Saturday 25 June 2011, Jonas Bonn wrote:
>> > On Sat, 2011-06-25 at 12:04 +0200, Ingo Molnar wrote:
>> > > Also, and more importantly, don't we generally do such things via
>> > > __weak aliases, because the result looks cleaner and needs no changes
>> > > for architectures beyond the removal of the generic functions? We
>> > > have excluded broken toolchains that miscompile/mislink __weak IIRC
>> > > so __weak ought to work.
>> >
>> > When we discussed this briefly yesterday, both Rusty and Arnd showed a
>> > preference for not using __weak aliases... I'll leave it to them to
>> > comment further.
>> >
>> > The alternative patch that just provides __weak implementations for
>> > these hooks is much less invasive than the patch I sent, effectively
>> > touching only kernel/module.c
>> >
>> > Let me know which is preferable.
>>
>> I don't care much either way, you would get my Ack for both solutions.
>> The __weak approach would definitely make a simpler patch, and the
>> patch you sent adds extra complexity because of the
>> asm_generic_moduleloader_hooks macro you used to avoid having to
>> change all other architectures.
>
> I think you misread me.  If all else is equal, I dislike weak functions.
> But AFAICT the two standard mechanisms are #ifdef HAVE_ARCH and __weak.
> Inventing a third one is not going to be a win.

It's not inventing a new one, the third one is already in use.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
