Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab0HUOyg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 10:54:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38488 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab0HUOyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 10:54:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type
         :content-transfer-encoding;
        b=kJIj+MWlyX3mc5+DSln7WMOdaTRRX12JLmtEptJ66KNVcSxrjq55THFD+aSAq/a2Cp
         bX8oDgN7L21s6USNsmGz3MxZ4jQ0fe6goourwanPlHHorJ0gTlbqfYRKBhdtJBSTsGvg
         e7ueNem9fjk14va0Pl6eonuwpbdPaSfJb8rbk=
Message-ID: <4C6FE8A5.30309@gnutls.org>
Date: Sat, 21 Aug 2010 16:54:29 +0200
From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: =?UTF-8?B?TWlsb3NsYXYgVHJtYcSN?= <mitr@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 01/19] User-space API definition
References: <1282293963-27807-1-git-send-email-mitr@redhat.com> <1282293963-27807-2-git-send-email-mitr@redhat.com> <AANLkTinzUuihbS_Znm1rgxPPxiLTXeNx8ySF8LHqU=Jz@mail.gmail.com>
In-Reply-To: <AANLkTinzUuihbS_Znm1rgxPPxiLTXeNx8ySF8LHqU=Jz@mail.gmail.com>
X-Enigmail-Version: 1.0.1
OpenPGP: id=96865171
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2010 03:09 PM, Kyle Moffett wrote:

>> This patch introduces the new user-space API, <ncr.h>.
>>
>> Quick overview:
>>
>> * open("/dev/crypto") to get a FD, which acts as a namespace for key and
>>  session identifiers.
>>
>> * ioctl(NCRIO_KEY_INIT) to allocate a key object; then generate the key
>>  material inside the kernel, load a plaintext key, unwrap a key, or
>>  derive a key.  Similarly the key material can be copied out of the
>>  kernel or wrapped.
>>
>> [...snip...]
> 
> Ugh... We already have one very nice key/keyring API in the kernel
> (see Documentation/keys.txt) that's being used for crypto keys for
> NFSv4, AFS, etc.  Can't you just add a bunch of cryptoapi key types to
> that API instead?

It is not that simple. My understanding of the keyring API is that it
allows exporting of the keys to user-space and this crypto API
explicitly prevents that, so enhancing the API that way will remove the
benefits of using it. It would be ideal to combine somehow those
solutions but this is more elaborate work than adding a bunch of new key
types. If anyone is interested in attempting that I'd be glad to help.


regards,
Nikos
