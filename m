Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab2FLI1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:27:08 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:47489 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751535Ab2FLI1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:27:03 -0400
Date: Tue, 12 Jun 2012 16:26:51 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: aes - make assembler implementation default
 for i386 and x86-64
Message-ID: <20120612082651.GA13419@gondor.apana.org.au>
References: <20120530215333.32995tjzj9dr4jwo@www.81.fi>
 <20120609145055.12766.42439.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120609145055.12766.42439.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2012 at 05:50:55PM +0300, Jussi Kivilinna wrote:
> AES is often built-in and therefore implementations other than aes-generic
> don't get autoloaded by module-aliases. This is solved for aes-ni by cpuid
> autoloading, but for x86-64/i586 assembler implementation cpuid matching
> does not make much sense (aes-generic built-in but overridden by x86-64/i586
> assembler implementation module). Instead change Kconfig so that assembler
> implementation is default on x86-64 and i386.
> 
> This patch also splits common parts exported to assembler implementations
> from aes-generic to new module aes-common.
> 
> Patch tested on x86-64, compile tested on i386 and arm.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

I like the idea but I'm not sure about where we draw the line.
E.g., why not enable padlock, or for that matter every single
hardware implementation of AES?

This can get unwieldy very quickly.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
