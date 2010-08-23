Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0HWGjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 02:39:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab0HWGjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 02:39:40 -0400
Subject: Re: [PATCH 00/19] RFC, v2: "New" /dev/crypto user-space interface
From: Tomas Mraz <tmraz@redhat.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Miloslav =?UTF-8?Q?Trma=C4=8D?= <mitr@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100820234811.GB10450@thunk.org>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
	 <20100820135612.GC4053@thunk.org> <4C6EB556.3050608@gmail.com>
	 <20100820234811.GB10450@thunk.org>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Mon, 23 Aug 2010 08:39:30 +0200
Message-Id: <1282545570.7909.32.camel@vespa.frost.loc>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 19:48 -0400, Ted Ts'o wrote: 
> On Fri, Aug 20, 2010 at 07:03:18PM +0200, Nikos Mavrogiannopoulos wrote:
> > On 08/20/2010 03:56 PM, Ted Ts'o wrote:
> > > On Fri, Aug 20, 2010 at 10:45:43AM +0200, Miloslav Trmaè wrote:
> > >> Hello, following is a patchset providing an user-space interface to
> > >> the kernel crypto API.  It is based on the older, BSD-compatible,
> > >> implementation, but the user-space interface is different.
> > > 
> > > What's the goal of exporting the kernel crypto routines to userspace,
> > > as opposed to just simply doing the crypto in userspace? 
> > 
> > This was the goal of the original cryptodev OpenBSD API and the
> > subsequent linux port in http://home.gna.org/cryptodev-linux/. In
> > typical PCs it might even be slower to use such an accelerator in kernel
> > space, but in embedded systems where the hardware version of AES might
> > be 100 times faster than the software it might make sense.
> 
> OK, but I hope that in that case, we don't go encouraging applications
> to use the /dev/crypto API directly.  I know a number of distributions
> have been standardizing on NSS as the library that all of their
> applications will use, such that by simply configuring libnss
> differently, the crypto can either be done in userspace, or it can be
> done in hardware, either for crypto acceleration purposes or for when
> the key is locked inside hardware can only be used with appropriate
> authentication to encrypt or sign data passed to the hardware device.

Yes, this exactly is the plan. All the major crypto libraries - NSS,
OpenSSL, libgcrypt - are going to be patched to use the kernel API in
case they are configured to. By default they will still be using their
internal implementation of the cryptographic algorithms. Of course there
still might be some applications (for example glibc libcrypt password
hashing) that decide to use the kernel interface directly, but these
will be a very small minority I think.

-- 
Tomas Mraz
No matter how far down the wrong road you've gone, turn back.
                                              Turkish proverb

