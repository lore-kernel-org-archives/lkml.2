Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab0K2S0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:26:42 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48117 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab0K2S0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:26:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:x-duff:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=h2aEEB+8KVYbKK2eTI+eGO/o2EywmJDiZmA0OFZvcJv8YVeXHS9LFUU+29VOQs1/vU
         FU9suRQR7W5vCV7qB8VGCiSZo8dQtShpmZpIyv30bCPv6RPoQ4ldZS7TRDT4vdbcgPBZ
         YHr0fVM4hd0+i9LBvNyaWJhLDXJRzySnpP198=
Subject: Re: linux-next: Tree for November 29 (aesni-intel)
X-Duff: Duff Lite, Duff Dry, Duff Dark, Lady Duff, Raspberry Duff, Duff Zero
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Mathias Krause <minipli@googlemail.com>
In-Reply-To: <20101129083105.e202e922.randy.dunlap@oracle.com>
Date: Mon, 29 Nov 2010 19:26:31 +0100
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Huang Ying <ying.huang@intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <DAEDA952-8AD2-406D-9F37-33740F86FC59@googlemail.com>
References: <20101129140335.19800705.sfr@canb.auug.org.au> <20101129083105.e202e922.randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.2010, 17:31 Randy Dunlap wrote:
> On Mon, 29 Nov 2010 14:03:35 +1100 Stephen Rothwell wrote:
> 
>> Hi all,
>> 
>> Changes since 20101126:
> 
> 
> on i386 builds, I get tons of these (and more) errors:
> 
> arch/x86/crypto/aesni-intel_asm.S:841: Error: bad register name `%r12'
> arch/x86/crypto/aesni-intel_asm.S:842: Error: bad register name `%r13'
> arch/x86/crypto/aesni-intel_asm.S:843: Error: bad register name `%r14'
> arch/x86/crypto/aesni-intel_asm.S:844: Error: bad register name `%rsp'
> arch/x86/crypto/aesni-intel_asm.S:849: Error: bad register name `%rsp'
> arch/x86/crypto/aesni-intel_asm.S:850: Error: bad register name `%rsp'
> arch/x86/crypto/aesni-intel_asm.S:851: Error: bad register name `%r9'
> 
> even though the kernel .config file says:
> 
> CONFIG_CRYPTO_AES=m
> CONFIG_CRYPTO_AES_586=m
> CONFIG_CRYPTO_AES_NI_INTEL=m
> 
> Should arch/x86/crypto/aesni-intel_asm.S be testing
> #ifdef CONFIG_X86_64
> instead of
> #ifdef __x86_64__
> or does that not matter?
> 
> or is this a toolchain issue?

Well, __x86_64__ should be a build-in define of the compiler while
CONFIG_X86_64 is defined for 64 bit builds in include/generated/autoconf.h.
So by using the latter we should be on the safe side but if your compiler
defines __x86_64__ for 32-bit builds it's simply broken. Also git grep
showed quite a few more places using __x86_64__ so those would miscompile on
your toolchain, too.

But it looks like linux-next is just missing
559ad0ff1368baea14dbc3207d55b02bd69bda4b from Herbert's git repo at
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git.
That should fix the build issue.

Kind Regards,
Mathias
