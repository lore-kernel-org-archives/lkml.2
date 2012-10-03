Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab2JCGxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 02:53:33 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33780 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab2JCGxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 02:53:31 -0400
Message-ID: <506BE0E7.1070701@pobox.com>
Date: Wed, 03 Oct 2012 02:53:27 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au
Subject: Re: [PATCH v0] Add SHA-3 hash algorithm
References: <20121003054542.GA2416@havoc.gtf.org> <20121003.020619.772556428995851933.davem@davemloft.net>
In-Reply-To: <20121003.020619.772556428995851933.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 02:06 AM, David Miller wrote:
> From: Jeff Garzik <jeff@garzik.org>
> Date: Wed, 3 Oct 2012 01:45:42 -0400
>
>> 1) tcrypt setup blatantly wrong.  What is the best setup here?  Define a
>> separate entry for each digest length?  Is there some special string
>> descriptor format that is desired, like "sha3-256" or "sha3(256)"?
>
> Good question.  The base name should probably be something without
> dashes.  Maybe "sha3_256", but yeah "sha3256" would look rediculous.

Well, the more basic question was...  what to do when the digest length 
is easily variable, vis a vis kernel hash APIs?

Keccak message digest size may fall anywhere within the range 8 bits - 
1600 bits at runtime.  You choose the digest size when you init the 
context.  In contrast, the kernel interface appears to require a 
hardcoded size, chosen at driver compile time.

My patch picks sizes found in common use, consistent with existing 
kernel practice.  However, it is valid for another Keccak user to 
produce a 1600 bit hash, or a 1592 bit hash, or a 1584 bit hash, etc., etc.

Maybe my patch is the best we can do in the current kernel, if dynamic 
digest size is not currently possible. Register "sha3_224", "sha3_256", 
... as you describe, and wait for actual users to appear with 
unsupported digest sizes.

	Jeff



