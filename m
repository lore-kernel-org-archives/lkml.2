Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab0ICJSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:18:49 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:34896 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab0ICJSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:18:48 -0400
Date: Fri, 3 Sep 2010 17:18:42 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Miloslav =?utf-8?B?VHJtYcSN?= <mitr@redhat.com>
Cc: linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/19] User-space API definition
Message-ID: <20100903091842.GC28952@gondor.apana.org.au>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com> <1282293963-27807-2-git-send-email-mitr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1282293963-27807-2-git-send-email-mitr@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 10:45:44AM +0200, Miloslav Trmač wrote:
> This patch introduces the new user-space API, <ncr.h>.
> 
> Quick overview:
> 
> * open("/dev/crypto") to get a FD, which acts as a namespace for key and
>   session identifiers.
> 
> * ioctl(NCRIO_KEY_INIT) to allocate a key object; then generate the key
>   material inside the kernel, load a plaintext key, unwrap a key, or
>   derive a key.  Similarly the key material can be copied out of the
>   kernel or wrapped.
> 
> * ioctl(NCRIO_SESSION_INIT) to allocate a crypto session (to encrypt,
>   decrypt, hash, sign, or verify signature), then
>   ioctl(NCRIO_SESSION_UPDATE) to act on chunks of data.  Deallocate the
>   session, and optionally retrieve session results (e.g. hash or
>   signature), using ioctl(NCRIO_SESSION_FINAL).
> 
>   There is also NCRIO_SESSION_ONCE for an one-shot crypto operation
>   using a single user->kernel context switch.
> 
> Full documentation of the interface is in
> Documentation/crypto/userspace.txt .

Thanks for the updated patch-set.  It does indeed fulfil some
of the requirements raised earlier.

However, as far as I can see this still does not address the
extensibility.  For example, say we want add an interface to
allow the xoring of two arbitrary data streams using DMA offload,
this interface would make that quite awkward.

In fact the whole interface is really tailored to the traditional
encryption/hash operations that BSD provided so I think this is not
a good foundation for our user-space API.

I will be looking at this myself so please stay tuned and be ready
to yell if you see that your requirements are not met.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
