Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab0K2SxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:53:07 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50520 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab0K2SxD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:53:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N5MuCANW0rxcaA0KUsRXXa78vX33l+sSu4BsN9MXAoRMeiFfZ+X3NtESNVOStZW1Fb
         BSmbPlC/CDjIbsHkBWElQ63kB9WRJXcgCT4z+IQh5/lTLuZwPN8EdPBUHm6HY2usogcZ
         +5jfjaZ2YlzLNh+dowuvThxxqdMFTV1bJa7bo=
MIME-Version: 1.0
In-Reply-To: <20101129145717.GA20232@gondor.apana.org.au>
References: <20101129140335.19800705.sfr@canb.auug.org.au>
	<AANLkTikiZoNM9zpXw3wSK7-uqh+ZYMpJ+wg0wPpBs_kx@mail.gmail.com>
	<20101129145717.GA20232@gondor.apana.org.au>
Date: Mon, 29 Nov 2010 19:53:02 +0100
Message-ID: <AANLkTinV35OkDownhmqU5=5=2c=6G+sWEhdYpobVMM-U@mail.gmail.com>
Subject: Re: linux-next: Tree for November 29
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/29 Herbert Xu <herbert@gondor.apana.org.au>:
> On Mon, Nov 29, 2010 at 09:47:38AM +0000, Zimny Lech wrote:
>> Ave
>>
>> 2010/11/29 Stephen Rothwell <sfr@canb.auug.org.au>:
>> > Hi all,
>> >
>> > Changes since 20101126:
>>
>>
>> Setup is 14188 bytes (padded to 14336 bytes).
>> System is 1267 kB
>> CRC 61cea148
>> Kernel: arch/x86/boot/bzImage is ready  (#1)
>>   Building modules, stage 2.
>>   MODPOST 537 modules
>> ERROR: "sock_no_mmap" [crypto/algif_skcipher.ko] undefined!
>
> I hope this patch fixes it for you.

Thanks, I'll check it in tomorrows -next.

>
> commit 7451708f39db19a8303bb7fb95f00aca9f673cb5
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Mon Nov 29 22:56:03 2010 +0800
>
>    crypto: af_alg - Add dependency on NET
>
>    Add missing dependency on NET since we require sockets for our
>    interface.
>
>    Should really be a select but kconfig doesn't like that:
>
>    net/Kconfig:6:error: found recursive dependency: NET -> NETWORK_FILESYSTEMS -> AFS_FS -> AF_RXRPC -> CRYPTO -> CRYPTO_USER_API_HASH -> CRYPTO_USER_API -> NET
>
>    Reported-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>
>    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 467491d..96b0e55 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -848,6 +848,7 @@ config CRYPTO_USER_API
>
>  config CRYPTO_USER_API_HASH
>        tristate "User-space interface for hash algorithms"
> +       depends on NET
>        select CRYPTO_HASH
>        select CRYPTO_USER_API
>        help
> @@ -856,6 +857,7 @@ config CRYPTO_USER_API_HASH
>
>  config CRYPTO_USER_API_SKCIPHER
>        tristate "User-space interface for symmetric key cipher algorithms"
> +       depends on NET
>        select CRYPTO_BLKCIPHER
>        select CRYPTO_USER_API
>        help
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>



-- 
Slawa!
Zimny "Spie dziadu!" Lech z Wawelu

That is not dead which can eternal lie.
And with strange aeons even death may die.
