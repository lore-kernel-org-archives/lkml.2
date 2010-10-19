Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab0JSMtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 08:49:12 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:60674 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab0JSMtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 08:49:11 -0400
Date: Tue, 19 Oct 2010 20:49:08 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: tadeusz.struk@intel.com
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        aidan.o.mahony@intel.com, gabriele.paoloni@intel.com,
        adrian.hoban@intel.com
Subject: Re: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Message-ID: <20101019124908.GA12898@gondor.apana.org.au>
References: <4CB41CED.mailDED1NSGGA@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB41CED.mailDED1NSGGA@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 09:31:41AM +0100, tadeusz.struk@intel.com wrote:
> Hi Herbert,
> Resubmitting the two other patches as requested.
> Thanks,
> Tadeusz
> 
> >From 06444d8a95458d807ae14699e557739281d0b026 Mon Sep 17 00:00:00 2001
> From: Adrian Hoban <ahoban@allen.ir.intel.com>
> Date: Fri, 10 Sep 2010 18:08:45 +0100
> Subject: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
> 
> This patch adds an optimized RFC4106 AES-GCM implementation for 64-bit
> kernels. It supports 128-bit AES key size. This leverages the crypto
> AEAD interface type to facilitate a combined AES & GCM operation to
> be implemented in assembly code. The assembly code leverages Intel(R)
> AES New Instructions and the PCLMULQDQ instruction.

OK this patch applies now at least.  However it doesn't build:

  AS [M]  arch/x86/crypto/aesni-intel_asm.o
arch/x86/crypto/aesni-intel_asm.S: Assembler messages:
arch/x86/crypto/aesni-intel_asm.S:803: Error: no such instruction: `aesenc 16*1(%rdi),%xmm6'
arch/x86/crypto/aesni-intel_asm.S:803: Error: no such instruction: `aesenc 16*1(%rdi),%xmm7'
arch/x86/crypto/aesni-intel_asm.S:803: Error: no such instruction: `aesenc 16*1(%rdi),%xmm8'
...

I suppose you can't rely on these new binutils instructions just
yet.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
