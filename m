Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab1IAG0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 02:26:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40437 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab1IAG0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 02:26:09 -0400
Message-ID: <4E5F257F.9060202@gnutls.org>
Date: Thu, 01 Sep 2011 08:26:07 +0200
From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Icedove/3.1.12
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: cryptodev-linux-devel@gna.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
References: <20110901021534.GA26330@gondor.apana.org.au>
In-Reply-To: <20110901021534.GA26330@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 04:15 AM, Herbert Xu wrote:
> Nikos Mavrogiannopoulos<nmav@gnutls.org>  wrote:
>>
>> Given my benchmarks have no issues, it is not apparent to me why one
>> should use AF_ALG instead of cryptodev. I do not know though why AF_ALG
>> performs so poor. I'd speculate by blaming it on the usage of the socket
>> API and the number of system calls required.
> The target usage of AF_ALG is hardware offload devices that cannot
> be directly used in user-space, not software crypto on implementations
> such as AESNI/Padlock.
> Going through the kernel to use something like AESNI/Padlock or
> software crypto is insane.
> Given the intended target case, your numbers are pretty much
> meaningless as cryptodev's performance can be easily beaten
> by a pure user-space implementation.

Actually this is the reason of the ecb(cipher-null) comparison. To 
emulate the case of a hardware offload device. I tried to make that 
clear in the text, but may not be. If you see AF_ALG performs really bad 
on that case. It performs better when a software or a padlock 
implementation of AES is involved (which as you say it is a useless 
use-case).

Of course, I don't own such an offloading device and cannot test it 
directly. If you have different values from a benchmark with an actual 
hardware accelerator, I'll be happy to include them.

regards,
Nikos
