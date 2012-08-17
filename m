Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab2HQITS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 04:19:18 -0400
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:45707 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab2HQISa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 04:18:30 -0400
Message-ID: <20120817111826.15226265ph07g70g@www.81.fi>
Date: Fri, 17 Aug 2012 11:18:26 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: David Daney <ddaney.cavm@gmail.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        herbert@gondor.hengli.com.au,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: on stack dynamic allocations
References: <CALLzPKYzc5FwPFTn5Ztg58vfkMO2EZ8P-MLEmVXRqdBE+CkkSg@mail.gmail.com>
 <502D6691.5010101@gmail.com>
In-Reply-To: <502D6691.5010101@gmail.com>
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

Quoting David Daney <ddaney.cavm@gmail.com>:

> On 08/16/2012 02:20 PM, Kasatkin, Dmitry wrote:
>> Hello,
>>
>> Some places in the code uses variable-size allocation on stack..
>> For example from hmac_setkey():
>>
>> 	struct {
>> 		struct shash_desc shash;
>> 		char ctx[crypto_shash_descsize(hash)];
>> 	} desc;
>>
>>
>> sparse complains
>>
>> CHECK   crypto/hmac.c
>> crypto/hmac.c:57:47: error: bad constant expression
>>
>> I like it instead of kmalloc..
>>
>> But what is position of kernel community about it?
>
> If you know that the range of crypto_shash_descsize(hash) is  
> bounded, just use the upper bound.
>
> If the range of crypto_shash_descsize(hash) is unbounded, then the  
> stack will overflow and ... BOOM!
>

Quick look shows that largest crypto_shash_descsize() would be with  
hmac+s390/sha512, 16 + 332 = 348. Crypto-api also prevents registering  
shash with descsize larger than (PAGE_SIZE / 8).

-Jussi

