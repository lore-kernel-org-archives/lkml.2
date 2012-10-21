Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2JUMgx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 08:36:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60504 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab2JUMgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 08:36:52 -0400
Message-ID: <5083EC61.8070505@ursulin.net>
Date: Sun, 21 Oct 2012 13:36:49 +0100
From: Tvrtko Ursulin <tvrtko@ursulin.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Zdenek Kaspar <zkaspar82@gmail.com>
CC: dm-crypt@saout.de, Milan Broz <gmazyland@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: cryptsetup not working under 3.6 - regression from 3.4?
References: <50830D33.5050807@ursulin.net> <5083C61C.5090807@gmail.com> <5083E4A8.3060501@ursulin.net> <5083E87B.2080908@gmail.com>
In-Reply-To: <5083E87B.2080908@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/10/12 13:20, Zdenek Kaspar wrote:
>>> I would say you are still missing some modules.
>>>
>>>> Kernel says this:
>>>>     device-mapper: table: 252:1: crypt: Error allocating crypto tfm
>>>>     device-mapper: ioctl: error adding target to table
>>>
>>> It complains about aes-cbc-essiv:sha256.
>>>
>>> It can be missing CBC od SHA256, but according the message I bet
>>> you have no "cbc" block cipher mode module compiled.
>>>
>>> Can you grep your final .config for CONFIG_CRYPTO_CBC and
>>> CONFIG_CRYPTO_SHA256 a paste it here?
>>
>> I both working 3.4 and non-working 3.6 situation is the same:
>>
>> CONFIG_CRYPTO_CBC=y
>> CONFIG_CRYPTO_SHA256=m
>
> Compare please:
> grep CONFIG_CRYPTO /boot/config-3.4
> grep CONFIG_CRYPTO /boot/config-3.6
>
> One of the problem could be that your configuration misses something
> like: CONFIG_CRYPTO_BLKCIPHER, CONFIG_CRYPTO_MANAGER, etc.. or some of
> those could changed into modules and are not getting loaded..

Here it is:

--- 3.4	2012-10-21 13:32:27.289602863 +0100
+++ 3.6	2012-10-21 13:32:23.824602841 +0100
@@ -1,3 +1,4 @@
+CONFIG_CRYPTO_ABLK_HELPER_X86=m
  CONFIG_CRYPTO_AEAD2=y
  CONFIG_CRYPTO_AEAD=m
  CONFIG_CRYPTO_AES=m
@@ -27,15 +28,14 @@
  CONFIG_CRYPTO_CTS=m
  CONFIG_CRYPTO_DEFLATE=m
  CONFIG_CRYPTO_DES=m
-CONFIG_CRYPTO_DEV_PADLOCK_AES=m
-CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
-CONFIG_CRYPTO_DEV_PADLOCK=y
+# CONFIG_CRYPTO_DEV_PADLOCK is not set
  CONFIG_CRYPTO_ECB=y
  CONFIG_CRYPTO_FCRYPT=m
  CONFIG_CRYPTO_GCM=m
  CONFIG_CRYPTO_GF128MUL=m
  CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m
  CONFIG_CRYPTO_GHASH=m
+CONFIG_CRYPTO_GLUE_HELPER_X86=m
  CONFIG_CRYPTO_HASH2=y
  CONFIG_CRYPTO_HASH=y
  CONFIG_CRYPTO_HMAC=y
@@ -64,6 +64,7 @@
  CONFIG_CRYPTO_SALSA20_X86_64=m
  CONFIG_CRYPTO_SEED=m
  CONFIG_CRYPTO_SEQIV=m
+CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
  CONFIG_CRYPTO_SERPENT=m
  CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
  CONFIG_CRYPTO_SHA1=m
@@ -73,6 +74,7 @@
  CONFIG_CRYPTO_TEA=m
  # CONFIG_CRYPTO_TEST is not set
  CONFIG_CRYPTO_TGR192=m
+CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m
  CONFIG_CRYPTO_TWOFISH_COMMON=m
  CONFIG_CRYPTO_TWOFISH=m
  CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m

Tvrtko

