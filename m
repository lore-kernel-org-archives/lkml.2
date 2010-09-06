Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab0IFMRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:17:16 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:52337 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab0IFMRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:17:15 -0400
Date: Mon, 6 Sep 2010 20:17:08 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Miloslav Trmac <mitr@redhat.com>
Cc: Kyle Moffett <kyle@moffetthome.net>, linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 01/19] User-space API definition
Message-ID: <20100906121708.GA26354@gondor.apana.org.au>
References: <1278368294.1123931282577639823.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com> <1269957386.1124701282577860651.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269957386.1124701282577860651.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 11:37:40AM -0400, Miloslav Trmac wrote:
>
> I can see almost no overlap between the two sets of requirements.  Probably the only common use case is handling session keys (e.g. keys used in a kerberos ticket), which should be stored in the kernel for the duration of the session, made available to each process in the session, and available as keys for kernel crypto.  Such keys will be in the minority, though, and it seems to me the best approach for handling these is to allow key export/import from/to keyring keys in addition to export/import from/to data in userspace: the long-term storage would be handled by the existing keyring API, which stores the key as unformatted binary data, and import into the crypto context would convert the key into the internal representation more suitable for crypto.
> 
> I have seriously considered the keyring API, and this is what I came up with - but I'd love to be shown a better way.

FWIW adding a second key management system to the kernel is
totally out of the question.

If the existing system doesn't work for you, find a way to build
on it so that it does.  Adding a second system that pretty much
does the same thing is unacceptable.

Also, the key management for secret keys that you've added should
not be the only mode offered to the user.  Most people do not need
the separation between key setting and encryption/decryption.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
