Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213Ab1GaNYK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 09:24:10 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34962 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1GaNYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 09:24:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110730134650.GA26753@gondor.apana.org.au>
References: <1311529994-7924-1-git-send-email-minipli@googlemail.com>
	<1311529994-7924-2-git-send-email-minipli@googlemail.com>
	<20110728145812.GA8396@gondor.apana.org.au>
	<CA+rthh-=qKpYM-9F0e=6DUpqxXWbMuMcXnGq9cZTK0V=Kbpg0A@mail.gmail.com>
	<20110730134650.GA26753@gondor.apana.org.au>
Date: Sun, 31 Jul 2011 15:24:04 +0200
Message-ID: <CA+rthh-SJ_t5T5=u-gdeaJb=Zh4k4Pdf1yKNqrXbPeGOYt3i6g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] crypto, sha1: export sha1_update for reuse
From: Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 3:46 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Jul 28, 2011 at 05:29:35PM +0200, Mathias Krause wrote:
>> On Thu, Jul 28, 2011 at 4:58 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> > On Sun, Jul 24, 2011 at 07:53:13PM +0200, Mathias Krause wrote:
>> >>
>> >> diff --git a/include/crypto/sha.h b/include/crypto/sha.h
>> >> index 069e85b..7c46d0c 100644
>> >> --- a/include/crypto/sha.h
>> >> +++ b/include/crypto/sha.h
>> >> @@ -82,4 +82,9 @@ struct sha512_state {
>> >>       u8 buf[SHA512_BLOCK_SIZE];
>> >>  };
>> >>
>> >> +#if defined(CONFIG_CRYPTO_SHA1) || defined (CONFIG_CRYPTO_SHA1_MODULE)
>> >> +extern int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
>> >> +                           unsigned int len);
>> >> +#endif
>> >
>> > Please remove the unnecessary #if.
>>
>> The function will only be available when crypto/sha1_generic.o will
>> either be build into the kernel or build as a module. Without the #if
>> a potential wrong user of this function might not be detected as early
>> as at compilation time but as late as at link time, or even worse, as
>> late as on module load time -- which is pretty bad. IMHO it's better
>> to detect errors early, as in reading "error: implicit declaration of
>> function ‘crypto_sha1_update’" when trying to compile the code in
>> question instead of "Unknown symbol crypto_sha1_update" in dmesg when
>> trying to load the module. That for I would like to keep the #if.
>
> In order to be consistent please remove the ifdef.  In most
> similar cases in the crypto subsystem we don't do this.  As
> adding such ifdefs all over the place would gain very little,
> I'd much rather you left it out.

Noting that this function wasn't exported before and the only user
(sha-ssse3) ensures its availability by other means, it should be okay
to remove the #if. I'll update the patch accordingly.

Any objections to the second patch?

Thanks,
Mathias
