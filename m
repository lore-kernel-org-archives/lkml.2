Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab0HUNKX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 09:10:23 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39350 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab0HUNKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 09:10:20 -0400
MIME-Version: 1.0
In-Reply-To: <1282293963-27807-2-git-send-email-mitr@redhat.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com> <1282293963-27807-2-git-send-email-mitr@redhat.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sat, 21 Aug 2010 09:09:58 -0400
Message-ID: <AANLkTinzUuihbS_Znm1rgxPPxiLTXeNx8ySF8LHqU=Jz@mail.gmail.com>
Subject: Re: [PATCH 01/19] User-space API definition
To: =?UTF-8?Q?Miloslav_Trma=C4=8D?= <mitr@redhat.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 04:45, Miloslav Trmač <mitr@redhat.com> wrote:
> This patch introduces the new user-space API, <ncr.h>.
>
> Quick overview:
>
> * open("/dev/crypto") to get a FD, which acts as a namespace for key and
>  session identifiers.
>
> * ioctl(NCRIO_KEY_INIT) to allocate a key object; then generate the key
>  material inside the kernel, load a plaintext key, unwrap a key, or
>  derive a key.  Similarly the key material can be copied out of the
>  kernel or wrapped.
>
> [...snip...]

Ugh... We already have one very nice key/keyring API in the kernel
(see Documentation/keys.txt) that's being used for crypto keys for
NFSv4, AFS, etc.  Can't you just add a bunch of cryptoapi key types to
that API instead?

David Howells added to CC, since I believe he wrote most of that code initially.

Cheers,
Kyle Moffett
