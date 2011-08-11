Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1HKPIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:08:54 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:36240 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1HKPIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:08:53 -0400
Date: Thu, 11 Aug 2011 23:08:40 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] crypto, x86: SSSE3 based SHA1 implementation
	for x86-64
Message-ID: <20110811150840.GA14503@gondor.apana.org.au>
References: <1311529994-7924-1-git-send-email-minipli@googlemail.com> <1311529994-7924-3-git-send-email-minipli@googlemail.com> <20110804064436.GA16247@gondor.apana.org.au> <4E43EC49.1040803@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E43EC49.1040803@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 10:50:49AM -0400, Andy Lutomirski wrote:
>
>> This is pretty similar to the situation with the Intel AES code.
>> Over there they solved it by using the asynchronous interface and
>> deferring the processing to a work queue.
>
> I have vague plans to clean up extended state handling and make  
> kernel_fpu_begin work efficiently from any context.  (i.e. the first  
> kernel_fpu_begin after a context switch could take up to ~60 ns on Sandy  
> Bridge, but further calls to kernel_fpu_begin would be a single branch.)

This is all well and good but you still need to deal with the
case of !irq_fpu_usable.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
