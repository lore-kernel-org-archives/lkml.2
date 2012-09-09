Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab2IIU0L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 16:26:11 -0400
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:54857 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab2IIU0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 16:26:09 -0400
Message-ID: <20120909232604.342762ujqb3iewow@www.81.fi>
Date: Sun, 09 Sep 2012 23:26:04 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Romain Francoise <romain@orebokech.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Linux 3.6-rc5
References: <CA+55aFwnPfdyTTG6WTuhChomg=t9nSS18xracq3iQ3F5+PWOog@mail.gmail.com>
 <87har7h84h.fsf@silenus.orebokech.com>
 <20120909191958.GB9782@gondor.apana.org.au>
In-Reply-To: <20120909191958.GB9782@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Herbert Xu <herbert@gondor.apana.org.au>:

>
> Can you try blacklisting/not loading sha1_ssse3 and aesni_intel
> to see which one of them is causing this crash? Of course if you
> can still reproduce this without loading either of them that would
> also be interesting to know.

This triggers with aes-x86_64 and sha1_generic (and sha256 & sha512)  
too, with following test added to tcrypt:
         case 46:
                 ret += tcrypt_test("authenc(hmac(sha1),cbc(aes))");
                 ret += tcrypt_test("authenc(hmac(sha256),cbc(aes))");
                 ret += tcrypt_test("authenc(hmac(sha512),cbc(aes))");
                 break;

-Jussi

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



