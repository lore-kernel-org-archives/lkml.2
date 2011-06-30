Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab1F3VCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:02:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43296 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab1F3VCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:02:37 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimX=t-zjOd80Vux8YwipjfJ7hwetQ@mail.gmail.com>
References: <BANLkTi=dndbsjqbF7nTDJ0Qpvs=WNP=W6A@mail.gmail.com>
	<1307485173-32010-1-git-send-email-wad@chromium.org>
	<20110609153328.c00b23c0.akpm@linux-foundation.org>
	<BANLkTikJpjeoarMCEhaQ69g7UyM9-PqpVw@mail.gmail.com>
	<BANLkTimzZ5aRBiCm1TSy4yzfGUdchPeuMA@mail.gmail.com>
	<BANLkTinN_9q4u3UTfHAoL=rmAo+PKVf2jg@mail.gmail.com>
	<BANLkTi=y_+Pyp_zSuhU4LGzzfAio5Jg-KA@mail.gmail.com>
	<BANLkTimX=t-zjOd80Vux8YwipjfJ7hwetQ@mail.gmail.com>
Date: Thu, 30 Jun 2011 16:02:37 -0500
Message-ID: <BANLkTinGTX3dE_MjXVJXhKVEy2ZajRb9RA@mail.gmail.com>
Subject: Re: [PATCH v2] init: add root=PARTUUID=UUID,PARTNROFF=%d support
From: Will Drewry <wad@chromium.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>, Namhyung Kim <namhyung@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 3:23 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Sun, Jun 26, 2011 at 20:00, Will Drewry <wad@chromium.org> wrote:
>> On Sun, Jun 26, 2011 at 11:43 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>>> On Fri, Jun 24, 2011 at 21:53, Will Drewry <wad@chromium.org> wrote:
>>>
>>>> Upon further inspection, the code changes would not directly break any
>>>> existing code, but PARTUUID=...,PARTNROFF= would not be usable via the
>>>> other entrypoints to name_to_dev_t.  E.g., block2mtd or md because
>>>> they take in comma-separated parameters prior to calling
>>>> name_to_dev_t.  That seems like it'd be less than ideal.
>>>>
>>>> Kay,  Do you have a strong preference around the ,PARTNROFF= syntax?
>>>> I'm not sure what the cleanest approach is, but I'm inclined to finish
>>>> other patch cleanup (and documentation) and repost with '/' as the
>>>> separator instead of ','.   At present ',' is reused across several
>>>> places where devices are supplied by "name", but '/' is expected as
>>>> part of the normal path semantic.  The other option would be to use
>>>> ':' instead. ':' isn't usually overloaded as it is expected as part of
>>>> a the device major:minor naming scheme, but slashes seem more sane
>>>> even if weird:
>>>>
>>>>  PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF/PARTNROFF=1
>>>>
>>>> I'll repost along these lines unless someone indicates that this is
>>>> too grotesque to consider.
>>>
>>> Hmm, '/' might look a bit strange in the context of a path, which is
>>> the common use case for root=.
>>
>> Yeah - that was why I was considering colons too, but slashes seemed
>> less likely to have other weird expectations.
>>
>>> We catch PARTUUID before parsing any of the other options, right? So
>>> we can't really break anything.
>>
>> For root= parsing, it's always okay.  The problem is if you want to
>> use PARTUUID=...,PARTNR=.. as a device "name" in an argument to md= or
>> to mtd2block.  Both of those take their device name from a
>> comma-separated argument list.  While they could be fixed up to
>> support this syntax, it seems that it would make things pretty
>> confusing.  (The other option is to just not support this naming
>> scheme via those input paths.)
>>
>>> Fstab and mount options in general all use ',' to separate keywords,
>>> and I think we should do the same here. I think the ',' still looks
>>> more natural than an artificial '/' to avoid possibly breaking
>>> something we don't even call into. :)
>>
>> I think the comma looks better too, but I wasn't sure if it'd be fair
>> game to provide a early-init device resolution path that solely worked
>> for root= and not for the other consumers at that stage.  I'll see if
>> there is another way around this, but I'm not seeing anything offhand.
>
> Maybe name_to_dev_t() could work like strtoul(), and get a separator
> character passed, and return the remaining string it did not parse as
> belonging to one single device. That could simplify the string
> separation in callers too, if they decide to support the new options.
>
> But I see your point, and it might be nice in general to be able to
> easily identify the two PART* keys as belonging together, describing a
> single device. Maybe the slash is way to go, I don't have a better
> idea.

So I've fiddled with a few different options and went back to the
slash.  I'll repost in a new thread, but I'd appreciate any opinions.
It doesn't look too heinous in my config files and not starting with a
slash helps, but I do with it could have been cleaner.

thanks again!
will
