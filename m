Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab0ICJej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:34:39 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43298 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab0ICJeh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:34:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OWqHCMjsbG5srWkSAFA2IJGwNuoYkVE+3AiAqgS0gWW1Rjvub4yuz2Fvvk2Oxj0f/S
         oHxL69k6HdpMnndYZR3/SAeEYUfpuwMoCSURAc3JwGJF98I1kgmhIkMbJ9zNS7eosTd1
         X50Z1oBjFIxmgHYq+y968311iBTcSle8QobSE=
MIME-Version: 1.0
In-Reply-To: <20100903091842.GC28952@gondor.apana.org.au>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
	<1282293963-27807-2-git-send-email-mitr@redhat.com>
	<20100903091842.GC28952@gondor.apana.org.au>
Date: Fri, 3 Sep 2010 11:34:36 +0200
Message-ID: <AANLkTi=xtLpd7f_xxTa8G0H9L6wBn1r_SV8qTXwmOdB_@mail.gmail.com>
Subject: Re: [PATCH 01/19] User-space API definition
From: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: =?UTF-8?Q?Miloslav_Trma=C4=8D?= <mitr@redhat.com>,
        linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/3 Herbert Xu <herbert@gondor.apana.org.au>:

>> * ioctl(NCRIO_SESSION_INIT) to allocate a crypto session (to encrypt,
>>   decrypt, hash, sign, or verify signature), then
>>   ioctl(NCRIO_SESSION_UPDATE) to act on chunks of data.  Deallocate the
>>   session, and optionally retrieve session results (e.g. hash or
>>   signature), using ioctl(NCRIO_SESSION_FINAL).
>>   There is also NCRIO_SESSION_ONCE for an one-shot crypto operation
>>   using a single user->kernel context switch.
>> Full documentation of the interface is in
>> Documentation/crypto/userspace.txt .
>
> Thanks for the updated patch-set.  It does indeed fulfil some
> of the requirements raised earlier.
>
> However, as far as I can see this still does not address the
> extensibility.  For example, say we want add an interface to
> allow the xoring of two arbitrary data streams using DMA offload,
> this interface would make that quite awkward.

Although I think the current API could handle something like this, I
also think it is undesirable to do so. The API was designed with
cryptographic operations in mind, and its extensibility might better
be judged on how it can incorporate future cryptographic protocols
(sigma-proofs and other zero-knowledge protocols and other protocols
that I might not know of). An XOR operation, doesn't really fit into a
cryptographic API. It could however be included in the current design
with some utility ioctls() that address such helper operations. Even
better, I think a XOR operation deserves a system call, since it is
quite useful in a variety of applications, not only cryptographic
ones.

> In fact the whole interface is really tailored to the traditional
> encryption/hash operations that BSD provided so I think this is not
> a good foundation for our user-space API.

It supports much more than the openbsd API, but indeed it is designed
with cryptographic operations in mind and this limitation can allow a
semi-formal verification of its properties. I'll try to post a link to
the design document as soon.

regards,
Nikos
