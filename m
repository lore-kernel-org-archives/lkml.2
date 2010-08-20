Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab0HTXsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 19:48:38 -0400
Received: from thunk.org ([69.25.196.29]:44225 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab0HTXsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 19:48:36 -0400
Date: Fri, 20 Aug 2010 19:48:11 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
Cc: Miloslav =?utf-8?B?VHJtYcSN?= <mitr@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/19] RFC, v2: "New" /dev/crypto user-space interface
Message-ID: <20100820234811.GB10450@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	Miloslav =?utf-8?B?VHJtYcSN?= <mitr@redhat.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
	linux-kernel@vger.kernel.org
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
 <20100820135612.GC4053@thunk.org>
 <4C6EB556.3050608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C6EB556.3050608@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 07:03:18PM +0200, Nikos Mavrogiannopoulos wrote:
> On 08/20/2010 03:56 PM, Ted Ts'o wrote:
> > On Fri, Aug 20, 2010 at 10:45:43AM +0200, Miloslav Trmač wrote:
> >> Hello, following is a patchset providing an user-space interface to
> >> the kernel crypto API.  It is based on the older, BSD-compatible,
> >> implementation, but the user-space interface is different.
> > 
> > What's the goal of exporting the kernel crypto routines to userspace,
> > as opposed to just simply doing the crypto in userspace? 
> 
> This was the goal of the original cryptodev OpenBSD API and the
> subsequent linux port in http://home.gna.org/cryptodev-linux/. In
> typical PCs it might even be slower to use such an accelerator in kernel
> space, but in embedded systems where the hardware version of AES might
> be 100 times faster than the software it might make sense.

OK, but I hope that in that case, we don't go encouraging applications
to use the /dev/crypto API directly.  I know a number of distributions
have been standardizing on NSS as the library that all of their
applications will use, such that by simply configuring libnss
differently, the crypto can either be done in userspace, or it can be
done in hardware, either for crypto acceleration purposes or for when
the key is locked inside hardware can only be used with appropriate
authentication to encrypt or sign data passed to the hardware device.

If you encourage applications to use /dev/crypto directly, then either
(a) they will be much slower on PC's, or (b) the applications will
need to be rewritten when they are moved between your embedded devices
and standard PC's.

					- Ted
