Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab0KRJ0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:26:48 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:39186 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab0KRJ0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:26:46 -0500
Date: Thu, 18 Nov 2010 17:26:40 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tadeusz.struk@intel.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, aidan.o.mahony@intel.com,
        gabriele.paoloni@intel.com, adrian.hoban@intel.com
Subject: Re: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Message-ID: <20101118092640.GA9486@gondor.apana.org.au>
References: <4CC9946D.mailLH511GU0C@intel.com> <20101104190405.GA2501@gondor.apana.org.au> <20101117172331.3bbec734.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117172331.3bbec734.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 05:23:31PM -0800, Andrew Morton wrote:
> On Thu, 4 Nov 2010 14:04:05 -0500
> Herbert Xu <herbert@gondor.hengli.com.au> wrote:
> 
> > On Thu, Oct 28, 2010 at 04:19:09PM +0100, tadeusz.struk@intel.com wrote:
> > > Hi Herbert,
> > >    We have reworked the assembly to use macros instead of the new aesni instructions.
> > 
> > Both applied.  Thanks for your efforts!
> 
> Whatever's in today's linux-next is a big fail with gas-2.16.1.
> 
> Which was entirely predictable!  How often has this happened recently??
> 
> 
> arch/x86/crypto/aesni-intel_asm.S: Assembler messages:
> arch/x86/crypto/aesni-intel_asm.S:834: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm13'
> arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm5'
> arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
> arch/x86/crypto/aesni-intel_asm.S:866: Error: bad expression

Sorry, but I no longer have access to a binutils that is older
than 2.18 so I never saw this failure.

Tadeusz, could you please make an incremental patch that converts
all the pshufb instructions to macros?

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
