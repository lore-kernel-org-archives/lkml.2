Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab1FZQpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 12:45:22 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:33588 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab1FZQnh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 12:43:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cVjP2lqS7NuDqxstK79S/lguPpbvpKvBz4ATugDWsS6chgROr/P5czyvSqw7BxYLuo
         BBWapPkabo7yCYRP7t0PjC6LidHTY5mRoOcjvY6jM/3Wl3QF3/Aa036b6L5aO3aNEEY9
         mMoHrPnUaBxndmLLn64GnjYdnUsLYXs6MRC+Q=
MIME-Version: 1.0
In-Reply-To: <BANLkTimzZ5aRBiCm1TSy4yzfGUdchPeuMA@mail.gmail.com>
References: <BANLkTi=dndbsjqbF7nTDJ0Qpvs=WNP=W6A@mail.gmail.com>
 <1307485173-32010-1-git-send-email-wad@chromium.org> <20110609153328.c00b23c0.akpm@linux-foundation.org>
 <BANLkTikJpjeoarMCEhaQ69g7UyM9-PqpVw@mail.gmail.com> <BANLkTimzZ5aRBiCm1TSy4yzfGUdchPeuMA@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 26 Jun 2011 18:43:17 +0200
Message-ID: <BANLkTinN_9q4u3UTfHAoL=rmAo+PKVf2jg@mail.gmail.com>
Subject: Re: [PATCH v2] init: add root=PARTUUID=UUID,PARTNROFF=%d support
To: Will Drewry <wad@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>, Namhyung Kim <namhyung@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 21:53, Will Drewry <wad@chromium.org> wrote:

> Upon further inspection, the code changes would not directly break any
> existing code, but PARTUUID=...,PARTNROFF= would not be usable via the
> other entrypoints to name_to_dev_t.  E.g., block2mtd or md because
> they take in comma-separated parameters prior to calling
> name_to_dev_t.  That seems like it'd be less than ideal.
>
> Kay,  Do you have a strong preference around the ,PARTNROFF= syntax?
> I'm not sure what the cleanest approach is, but I'm inclined to finish
> other patch cleanup (and documentation) and repost with '/' as the
> separator instead of ','.   At present ',' is reused across several
> places where devices are supplied by "name", but '/' is expected as
> part of the normal path semantic.  The other option would be to use
> ':' instead. ':' isn't usually overloaded as it is expected as part of
> a the device major:minor naming scheme, but slashes seem more sane
> even if weird:
>
>  PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF/PARTNROFF=1
>
> I'll repost along these lines unless someone indicates that this is
> too grotesque to consider.

Hmm, '/' might look a bit strange in the context of a path, which is
the common use case for root=.

We catch PARTUUID before parsing any of the other options, right? So
we can't really break anything.

Fstab and mount options in general all use ',' to separate keywords,
and I think we should do the same here. I think the ',' still looks
more natural than an artificial '/' to avoid possibly breaking
something we don't even call into. :)

Thanks,
Kay
