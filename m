Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab2FRJCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:02:16 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:33235 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753628Ab2FRJCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:02:14 -0400
Date: Mon, 18 Jun 2012 17:02:01 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: aes - make assembler implementation default
 for i386 and x86-64
Message-ID: <20120618090201.GA25104@gondor.apana.org.au>
References: <20120530215333.32995tjzj9dr4jwo@www.81.fi>
 <20120609145055.12766.42439.stgit@localhost6.localdomain6>
 <20120612082651.GA13419@gondor.apana.org.au>
 <20120612212518.22246qw5kuyn2osg@www.81.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120612212518.22246qw5kuyn2osg@www.81.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 09:25:18PM +0300, Jussi Kivilinna wrote:
>
> Well, how about letting arch specific assembler implementations
> replace aes-generic
> completely.. in this case add "depends on !X86" on
> CRYPTO_AES_GENERIC. Hardware
> modules get autoloaded (cpuid/pci/platform/etc) but generic
> assembler implementation
> might as well be replacement as it cannot autoload depending on
> hardware support (or
> it can, but will be always loaded).

Perhaps we can just force a modprobe of a given algorithm at least
once for each boot (when requested for the first time).  I think
that should be easy to implement and should solve your problem
scenario.

What do you think?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
