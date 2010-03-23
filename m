Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab0CWVYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 17:24:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952Ab0CWVYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 17:24:37 -0400
Date: Tue, 23 Mar 2010 14:23:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [BUGFIX] Fix AES-NI CTR optimization compiling failure with gas
 2.16.1
Message-Id: <20100323142324.a53b20de.akpm@linux-foundation.org>
In-Reply-To: <1268377307.1640.491.camel@yhuang-dev.sh.intel.com>
References: <1268377307.1640.491.camel@yhuang-dev.sh.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010 15:01:47 +0800
Huang Ying <ying.huang@intel.com> wrote:

> Andrew Morton reported that AES-NI CTR optimization failed to compile
> with gas 2.16.1, the error message is as follow:
> 
> arch/x86/crypto/aesni-intel_asm.S: Assembler messages:
> arch/x86/crypto/aesni-intel_asm.S:752: Error: suffix or operands invalid for `movq'
> arch/x86/crypto/aesni-intel_asm.S:753: Error: suffix or operands invalid for `movq'
> 
> To fix this, a gas macro is defined to assemble movq with 64bit
> general purpose registers and XMM registers. The macro will generate
> the raw .byte sequence for needed instructions.
> 

Still no go.

arch/x86/crypto/aesni-intel_asm.S: Assembler messages:
arch/x86/crypto/aesni-intel_asm.S:752: Error: bad expression
arch/x86/crypto/aesni-intel_asm.S:752: Error: junk at end of line, first unrecognized character is `1'
arch/x86/crypto/aesni-intel_asm.S:753: Error: bad expression
arch/x86/crypto/aesni-intel_asm.S:753: Error: junk at end of line, first unrecognized character is `1'

it doesn't like this:

        REG_TYPE movq_r64_xmm_opd1_type \opd1

