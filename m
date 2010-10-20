Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab0JTKuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 06:50:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:16864 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab0JTKuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 06:50:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,354,1283756400"; 
   d="scan'208";a="338271737"
From: "Hoban, Adrian" <adrian.hoban@intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Struk, Tadeusz" <tadeusz.struk@intel.com>,
        "O Mahony, Aidan" <aidan.o.mahony@intel.com>,
        "Paoloni, Gabriele" <gabriele.paoloni@intel.com>
Date: Wed, 20 Oct 2010 11:49:10 +0100
Subject: RE: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Thread-Topic: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Thread-Index: ActvjBFMQsaqrmqcRFyQJAyoIREkewAAC29wAAFlYGAAKmThMA==
Message-ID: <CFBC532374C38D45810FA00BC2D2C204012D3E76C4@irsmsx502.ger.corp.intel.com>
References: <4CB41CED.mailDED1NSGGA@intel.com>
 <20101019124908.GA12898@gondor.apana.org.au>
 <44813D8942D35947805CBEEA94195BB001B135B69E@irsmsx505.ger.corp.intel.com>
 <24483BA4C9F69C43A7379639D35543D7C2F99F27@irsmsx502.ger.corp.intel.com>
In-Reply-To: <24483BA4C9F69C43A7379639D35543D7C2F99F27@irsmsx502.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herbert,

We have been using binutils v2.19. 

Can you please recommend the version(s) of binutils (gas) that we should test with before submitting a patch? V2.16.1, or perhaps the older version (2.12) described in /Documentation/Changes? 

We will retest with the recommended version, update the code and resubmit the patch ASAP. 

Cheers,
Adrian


-----Original Message-----
From: Herbert Xu [mailto:herbert@gondor.apana.org.au] 
Sent: Tuesday, October 19, 2010 1:49 PM
To: Struk, Tadeusz
Cc: linux-kernel@vger.kernel.org; linux-crypto@vger.kernel.org; O Mahony, Aidan; Paoloni, Gabriele; Hoban, Adrian
Subject: Re: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions

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

OK this patch applies now at least.  However it doesn't build:

  AS [M]  arch/x86/crypto/aesni-intel_asm.o
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
--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.


