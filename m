Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab1CHJdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:33:52 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:45296 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1CHJdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:33:49 -0500
Date: Tue, 8 Mar 2011 17:33:34 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James.Bottomley@hansenpartnership.com, hch@infradead.org,
        rdunlap@xenotime.net, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 12/12] iscsi-target: Add Makefile/Kconfig and update TCM
	top level
Message-ID: <20110308093334.GA21996@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299539747.19683.333.camel@haakon2.linux-iscsi.org>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel,apa
	na.lists.os.linux.scsi
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
>
>> > I should mention this is with the following .config:
>> > 
>> > CONFIG_CRYPTO_CRC32C=y
>> > CONFIG_CRYPTO_CRC32C_INTEL=m

This is why you get the unoptimised version.  Had you selected
both as built-in or both as modules, then it would have worked
as intended.
 
> What about the following to simply call request_module("crc32c_intel")
> at module_init() time and top the extra iscsi_login_setup_crypto()
> code..?

If we're going to do this we should do it in the crypto layer,
and not litter every single crypto API user with such crap.

Currently we don't invoke request_module unless no implementation
is reigstered for an algorithm.  You can change this so that it
also invokes request_module if we have not yet done so at least
once for that algorithm.

Patches are welcome.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
