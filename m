Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995Ab1ETHyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:54:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32924 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab1ETHyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:54:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XdkpID6Hh5aJ8tVBSQwgQHYdrST8a9O0CoWiLqiZuCcdV58em4L1uMBa8HtBRilSSq
         /x+ezrraCjurd5LnXzbHEwGqdR5L2VZLb2fv9WP/QKpftRb2wAcvayFJgnaGB5EsZB4l
         8rpCNefe+LYOi9OGPsnasTTgb1lBinH6YTkIQ=
MIME-Version: 1.0
In-Reply-To: <20110520072117.GA26787@p183>
References: <20110520061259.GA13483@p183>
	<BANLkTi=2yReXfrr7swhys7TgkuJ5r97jqQ@mail.gmail.com>
	<20110520064827.GA14185@p183>
	<20110519235449.ac0ac1c4.akpm@linux-foundation.org>
	<20110520072117.GA26787@p183>
Date: Fri, 20 May 2011 09:54:44 +0200
X-Google-Sender-Auth: ADmSL4AkhvfnEeIGB9M3UUUbIXw
Message-ID: <BANLkTim=2isrqtBCLoZN9kkeqCo1jcKkUw@mail.gmail.com>
Subject: Re: [PATCH] kstrtox: drop kstrtol()/kstrtoul() when possible
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        arnd@arndb.de, mmarek@suse.cz, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 09:21, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Thu, May 19, 2011 at 11:54:49PM -0700, Andrew Morton wrote:
>> On Fri, 20 May 2011 09:48:27 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:
>>
>> > On Fri, May 20, 2011 at 08:20:42AM +0200, Geert Uytterhoeven wrote:
>> > > On Fri, May 20, 2011 at 08:15, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> > > > If "long" and "long long" types are identical at runtime,
>> > > > kstrtol() can be aliased to kstrtoll().
>> > > >
>> > > > Unfortunately, one can't write
>> > > >
>> > > > __ __ __ __#if sizeof(long) == sizeof(long long) ...
>> > >
>> > > One can write #ifdef CONFIG_64BIT instead.
>> >
>> > And alignment will match, on any arch, now and in future?
>> > I don't think so.
>>
>> Don't worry about it.
>>
>> z:/usr/src/linux-2.6.39> grep -r "#[    ]*if.*CONFIG_64BIT" . | wc -l
>> 547
>>
>> So much other stuff will break that kstrtofoo is a drop in the bucket.
>
> Meh.
> The point was that patch is obviously correct and will work in future.
> CONFIG_64BIT means many things and you guys ask me to overload CONFIG_64BIT
> one more time.

In Linux, CONFIG_64BIT means that sizeof(long) == 8. Alignment of 8 byte longs
and 8 byte long long should be identical, as w.r.t. the CPU they're
the same type.

> On X32, CONFIG_64BIT trick already doesn't technically work.

Why? On X32, CONFIG_64bit is not set, and sizeof(long) == 4 and
sizeof(long long) == 8.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
