Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0HTRD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:03:27 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37589 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab0HTRDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:03:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=B/d734/b3H02V/CN2rF0sX178LbwHXr72v2+hfILHdmjaMf/gtZs4/i2skFAT2K2qf
         Kyqa8TWO2124FtIlwZiWLLEDYI9XvhUf8uXUi7kuFXa+rBVWOLffy+w81+CEg+cUW5O4
         Y45TycTMDy8ZHLGSNA7YB6bEG1mxuNuhu1isw=
Message-ID: <4C6EB556.3050608@gmail.com>
Date: Fri, 20 Aug 2010 19:03:18 +0200
From: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>,
        =?UTF-8?B?TWlsb3NsYXYgVHJtYcSN?= <mitr@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/19] RFC, v2: "New" /dev/crypto user-space interface
References: <1282293963-27807-1-git-send-email-mitr@redhat.com> <20100820135612.GC4053@thunk.org>
In-Reply-To: <20100820135612.GC4053@thunk.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 03:56 PM, Ted Ts'o wrote:
> On Fri, Aug 20, 2010 at 10:45:43AM +0200, Miloslav Trmač wrote:
>> Hello, following is a patchset providing an user-space interface to
>> the kernel crypto API.  It is based on the older, BSD-compatible,
>> implementation, but the user-space interface is different.
> 
> What's the goal of exporting the kernel crypto routines to userspace,
> as opposed to just simply doing the crypto in userspace? 

This was the goal of the original cryptodev OpenBSD API and the
subsequent linux port in http://home.gna.org/cryptodev-linux/. In
typical PCs it might even be slower to use such an accelerator in kernel
space, but in embedded systems where the hardware version of AES might
be 100 times faster than the software it might make sense.

However the design goal of this API is to separate cryptographic
operations from the applications. That is applications in userspace can
use keys, but the keys cannot be extracted from them, so for example
code injection in the web server will not be able to extract the private
key of the web service. (this approach is also required for
certification of linux on certain fields as Miloslav described in the
first post).

The interface is designed in a way that it can be wrapped by a PKCS #11
module and used transparently by other crypto libraries
(openssl/nss/gnutls). TPM is quite limited in this respect and cannot
fulfill this goal.

> So I'm bit at a list what's the whole point of this patch series.
> Could you explain that in the documentation, please?  Especially for
> crypto, explaining when something should be used, what the threat
> model is, etc., is often very important.

A detailed document describing this framework, threats and model is on
its way.


best regards,
Nikos
