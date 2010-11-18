Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab0KRBYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 20:24:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210Ab0KRBYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 20:24:06 -0500
Date: Wed, 17 Nov 2010 17:23:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: tadeusz.struk@intel.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, aidan.o.mahony@intel.com,
        gabriele.paoloni@intel.com, adrian.hoban@intel.com
Subject: Re: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Message-Id: <20101117172331.3bbec734.akpm@linux-foundation.org>
In-Reply-To: <20101104190405.GA2501@gondor.apana.org.au>
References: <4CC9946D.mailLH511GU0C@intel.com>
	<20101104190405.GA2501@gondor.apana.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Nov 2010 14:04:05 -0500
Herbert Xu <herbert@gondor.hengli.com.au> wrote:

> On Thu, Oct 28, 2010 at 04:19:09PM +0100, tadeusz.struk@intel.com wrote:
> > Hi Herbert,
> >    We have reworked the assembly to use macros instead of the new aesni instructions.
> 
> Both applied.  Thanks for your efforts!

Whatever's in today's linux-next is a big fail with gas-2.16.1.

Which was entirely predictable!  How often has this happened recently??


arch/x86/crypto/aesni-intel_asm.S: Assembler messages:
arch/x86/crypto/aesni-intel_asm.S:834: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm13'
arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm5'
arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
arch/x86/crypto/aesni-intel_asm.S:866: Error: bad expression
arch/x86/crypto/aesni-intel_asm.S:866: Error: junk at end of line, first unrecognized character is `0'
arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm6'
arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm7'
arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm8'
arch/x86/crypto/aesni-intel_asm.S:866: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm6'
arch/x86/crypto/aesni-intel_asm.S:866: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm7'
arch/x86/crypto/aesni-intel_asm.S:866: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm8'
arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:866: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:871: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm6'
arch/x86/crypto/aesni-intel_asm.S:871: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
arch/x86/crypto/aesni-intel_asm.S:871: Error: bad expression
arch/x86/crypto/aesni-intel_asm.S:871: Error: junk at end of line, first unrecognized character is `0'
arch/x86/crypto/aesni-intel_asm.S:871: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm7'
arch/x86/crypto/aesni-intel_asm.S:871: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm8'
arch/x86/crypto/aesni-intel_asm.S:871: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:871: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm7'
arch/x86/crypto/aesni-intel_asm.S:871: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:871: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm8'
arch/x86/crypto/aesni-intel_asm.S:871: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:871: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:871: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:871: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:876: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm7'
arch/x86/crypto/aesni-intel_asm.S:876: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
arch/x86/crypto/aesni-intel_asm.S:876: Error: bad expression
arch/x86/crypto/aesni-intel_asm.S:876: Error: junk at end of line, first unrecognized character is `0'
arch/x86/crypto/aesni-intel_asm.S:876: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm8'
arch/x86/crypto/aesni-intel_asm.S:876: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:876: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm8'
arch/x86/crypto/aesni-intel_asm.S:876: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:876: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:876: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:876: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:881: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm8'
arch/x86/crypto/aesni-intel_asm.S:881: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
arch/x86/crypto/aesni-intel_asm.S:881: Error: bad expression
arch/x86/crypto/aesni-intel_asm.S:881: Error: junk at end of line, first unrecognized character is `0'
arch/x86/crypto/aesni-intel_asm.S:881: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
arch/x86/crypto/aesni-intel_asm.S:881: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:881: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
arch/x86/crypto/aesni-intel_asm.S:881: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:881: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:881: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:881: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:889: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:889: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:889: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:889: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:889: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:889: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:889: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:889: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:889: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:889: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:889: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:889: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:905: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
arch/x86/crypto/aesni-intel_asm.S:915: Error: no such instruction: `pshufb %xmm2,%xmm1'
arch/x86/crypto/aesni-intel_asm.S:922: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:930: Error: suffix or operands invalid for `movq'
arch/x86/crypto/aesni-intel_asm.S:936: Error: suffix or operands invalid for `movq'
arch/x86/crypto/aesni-intel_asm.S:949: Error: suffix or operands invalid for `movq'
arch/x86/crypto/aesni-intel_asm.S:955: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm8'
arch/x86/crypto/aesni-intel_asm.S:968: Error: suffix or operands invalid for `movq'
arch/x86/crypto/aesni-intel_asm.S:972: Error: suffix or operands invalid for `movq'
arch/x86/crypto/aesni-intel_asm.S:1084: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm13'
arch/x86/crypto/aesni-intel_asm.S:1115: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm5'
arch/x86/crypto/aesni-intel_asm.S:1115: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
arch/x86/crypto/aesni-intel_asm.S:1115: Error: bad expression
arch/x86/crypto/aesni-intel_asm.S:1115: Error: junk at end of line, first unrecognized character is `0'
arch/x86/crypto/aesni-intel_asm.S:1115: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm6'
arch/x86/crypto/aesni-intel_asm.S:1115: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm7'
arch/x86/crypto/aesni-intel_asm.S:1115: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm8'
arch/x86/crypto/aesni-intel_asm.S:1115: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:1115: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm6'
arch/x86/crypto/aesni-intel_asm.S:1115: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:1115: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm7'
arch/x86/crypto/aesni-intel_asm.S:1115: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:1115: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm8'
arch/x86/crypto/aesni-intel_asm.S:1115: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:1115: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:1115: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:1115: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:1120: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm6'
arch/x86/crypto/aesni-intel_asm.S:1120: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
arch/x86/crypto/aesni-intel_asm.S:1120: Error: bad expression
arch/x86/crypto/aesni-intel_asm.S:1120: Error: junk at end of line, first unrecognized character is `0'
arch/x86/crypto/aesni-intel_asm.S:1120: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm7'
arch/x86/crypto/aesni-intel_asm.S:1120: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm8'
arch/x86/crypto/aesni-intel_asm.S:1120: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:1120: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm7'
arch/x86/crypto/aesni-intel_asm.S:1120: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:1120: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm8'
arch/x86/crypto/aesni-intel_asm.S:1120: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:1120: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:1120: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:1120: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:1125: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm7'
arch/x86/crypto/aesni-intel_asm.S:1125: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
arch/x86/crypto/aesni-intel_asm.S:1125: Error: bad expression
arch/x86/crypto/aesni-intel_asm.S:1125: Error: junk at end of line, first unrecognized character is `0'
arch/x86/crypto/aesni-intel_asm.S:1125: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm8'
arch/x86/crypto/aesni-intel_asm.S:1125: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:1125: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm8'
arch/x86/crypto/aesni-intel_asm.S:1125: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:1125: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:1125: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:1125: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:1130: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm8'
arch/x86/crypto/aesni-intel_asm.S:1130: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
arch/x86/crypto/aesni-intel_asm.S:1130: Error: bad expression
arch/x86/crypto/aesni-intel_asm.S:1130: Error: junk at end of line, first unrecognized character is `0'
arch/x86/crypto/aesni-intel_asm.S:1130: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
arch/x86/crypto/aesni-intel_asm.S:1130: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:1130: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
arch/x86/crypto/aesni-intel_asm.S:1130: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:1130: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:1130: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:1130: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:15: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:1141: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:1141: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:1141: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:1141: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:1141: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:1141: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:1141: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:1141: Error: non-constant expression in ".if" statement
arch/x86/crypto/aesni-intel_asm.S:1141: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm1'
arch/x86/crypto/aesni-intel_asm.S:1141: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm2'
arch/x86/crypto/aesni-intel_asm.S:1141: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm3'
arch/x86/crypto/aesni-intel_asm.S:1141: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm4'
arch/x86/crypto/aesni-intel_asm.S:1156: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
arch/x86/crypto/aesni-intel_asm.S:1166: Error: no such instruction: `pshufb %xmm2,%xmm1'
arch/x86/crypto/aesni-intel_asm.S:1172: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
arch/x86/crypto/aesni-intel_asm.S:1178: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm0'
arch/x86/crypto/aesni-intel_asm.S:1182: Error: suffix or operands invalid for `movq'
arch/x86/crypto/aesni-intel_asm.S:1188: Error: suffix or operands invalid for `movq'
arch/x86/crypto/aesni-intel_asm.S:1201: Error: suffix or operands invalid for `movq'
arch/x86/crypto/aesni-intel_asm.S:1208: Error: no such instruction: `pshufb SHUF_MASK(%rip),%xmm8'
arch/x86/crypto/aesni-intel_asm.S:1221: Error: suffix or operands invalid for `movq'
arch/x86/crypto/aesni-intel_asm.S:1225: Error: suffix or operands invalid for `movq'
make[2]: *** [arch/x86/crypto/aesni-intel_asm.o] Error 1
make[1]: *** [arch/x86/crypto] Error 2
make: *** [arch/x86] Error 2

