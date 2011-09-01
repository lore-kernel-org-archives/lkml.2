Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab1IACPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 22:15:50 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:42863 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab1IACPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 22:15:46 -0400
Date: Thu, 1 Sep 2011 12:15:34 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Cc: cryptodev-linux-devel@gna.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
Message-ID: <20110901021534.GA26330@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5A3FCC.2030504@gnutls.org>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikos Mavrogiannopoulos <nmav@gnutls.org> wrote:
>
> Given my benchmarks have no issues, it is not apparent to me why one
> should use AF_ALG instead of cryptodev. I do not know though why AF_ALG
> performs so poor. I'd speculate by blaming it on the usage of the socket
> API and the number of system calls required.

The target usage of AF_ALG is hardware offload devices that cannot
be directly used in user-space, not software crypto on implementations
such as AESNI/Padlock.

Going through the kernel to use something like AESNI/Padlock or
software crypto is insane.

Given the intended target case, your numbers are pretty much
meaningless as cryptodev's performance can be easily beaten
by a pure user-space implementation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
