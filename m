Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab0JTKYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 06:24:37 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39510 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab0JTKYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 06:24:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=eGLtKhukj+MgNexDMP8iZa16B/MvIw4NcuRUoTR0lQ0xGBcy3sn2MjA1nO/aNgYUdZ
         wH9MgC65z2M0f24Ouav+V3wyWbgIE0rp20zDNwvvwv8uNWfLSTr1Vb7LWpBqwkUav5E3
         NMhYFhqKjonKL45J7dcBY/v0w5TxpB2ys04sU=
MIME-Version: 1.0
In-Reply-To: <20101019134418.GA13514@gondor.apana.org.au>
References: <20100907084213.GA4610@gondor.apana.org.au>
	<20101019134418.GA13514@gondor.apana.org.au>
Date: Wed, 20 Oct 2010 12:24:33 +0200
X-Google-Sender-Auth: UZKxjj6vDloC7L9lm03wWSlsG0g
Message-ID: <AANLkTi=cmus+1fWBbqH8p=cw4G60+PF_572=5Au=TDxL@mail.gmail.com>
Subject: Re: RFC: Crypto API User-interface
From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cryptodev-linux-devel@gna.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 3:44 PM, Herbert Xu
<herbert@gondor.hengli.com.au> wrote:
> OK I've gone ahead and implemented the user-space API for hashes
> and ciphers.
> To recap this interface is designed to allow user-space programs
> to access hardware cryptographic accelerators that we have added
> to the kernel.
> The intended usage scenario is where a large amount of data needs
> to be processed where the benefits offered by hardware acceleration
> that is normally unavailable in user-space (as opposed to ones
> such as the Intel AES instruction which may be used directly from
> user-space) outweigh the overhead of going through the kernel.

What is the overall advantage of this API comparing to other existing
ones that achieve similar goals[0][1]?

Some observations:
1. To perform an encryption of data 6 system calls are made (I don't
count the 2 used for socket initialization since I suppose can be global
for all operations) and a file descriptor is assigned. The number of
system calls
made has great impact to the actual speed seen by userspace (as you said this
API is for user-space to access the high-speed peripherals that do encryption).
2. Due to the usage of read() and write() no zero-copy can happen for
user-space buffers[3].

regards,
Nikos

[0]. http://home.gna.org/cryptodev-linux/
[1]. http://home.gna.org/cryptodev-linux/ncr.html
[2]. The openbsd[0] api can do it with 3 system calls and NCR[1] with one,
and both require no file descriptor for each operation.
[3]. The openbsd[0] api and NCR[1] do zero-copy for user-space buffers.
