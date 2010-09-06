Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab0IFMd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:33:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35288 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab0IFMdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:33:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=fybDj+RJ4hme4Wze/TPMBVGiYaMHwB9SRBe/7CJq/6cK9A45HtHYxBkuH5GtJiLfji
         30I8XqVBWMU/NFcsFDQ/gLaxTzIGoCVCClrfCb17PcPv/b4BLelZMIMB8vhVc9is+z2P
         oDda6+lv+dcjimkqVLa32fvcglBzPdQ+AeAeo=
Message-ID: <4C84DFB0.1050206@gmail.com>
Date: Mon, 06 Sep 2010 14:33:52 +0200
From: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: Miloslav Trmac <mitr@redhat.com>, Kyle Moffett <kyle@moffetthome.net>,
        linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 01/19] User-space API definition
References: <1278368294.1123931282577639823.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com> <1269957386.1124701282577860651.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com> <20100906121708.GA26354@gondor.apana.org.au>
In-Reply-To: <20100906121708.GA26354@gondor.apana.org.au>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2010 02:17 PM, Herbert Xu wrote:
> On Mon, Aug 23, 2010 at 11:37:40AM -0400, Miloslav Trmac wrote:
>>
>> I can see almost no overlap between the two sets of requirements.  Probably the only common use case is handling session keys (e.g. keys used in a kerberos ticket), which should be stored in the kernel for the duration of the session, made available to each process in the session, and available as keys for kernel crypto.  Such keys will be in the minority, though, and it seems to me the best approach for handling these is to allow key export/import from/to keyring keys in addition to export/import from/to data in userspace: the long-term storage would be handled by the existing keyring API, which stores the key as unformatted binary data, and import into the crypto context would convert the key into the internal representation more suitable for crypto.
>>
>> I have seriously considered the keyring API, and this is what I came up with - but I'd love to be shown a better way.
> 
> FWIW adding a second key management system to the kernel is
> totally out of the question.
> 
> If the existing system doesn't work for you, find a way to build
> on it so that it does.  Adding a second system that pretty much
> does the same thing is unacceptable.
> 
> Also, the key management for secret keys that you've added should
> not be the only mode offered to the user.  Most people do not need
> the separation between key setting and encryption/decryption.

I think this is a misunderstanding. The NCR does not have a keyring. The
only common thing it has with a keyring is the word "key". The fact that
it holds a reference to the key being used for encryption doesn't really
make it a keyring. The kernel Keyring can be used with NCR to store keys
as well as any other keyring.

regards,
Nikos
