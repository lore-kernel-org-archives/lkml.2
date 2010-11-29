Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab0K2SyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:54:15 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:30367 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab0K2SyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:54:14 -0500
Message-ID: <4CF3F6CB.8080904@oracle.com>
Date: Mon, 29 Nov 2010 10:54:03 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mathias Krause <minipli@googlemail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Huang Ying <ying.huang@intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for November 29 (aesni-intel)
References: <20101129140335.19800705.sfr@canb.auug.org.au> <20101129083105.e202e922.randy.dunlap@oracle.com> <DAEDA952-8AD2-406D-9F37-33740F86FC59@googlemail.com>
In-Reply-To: <DAEDA952-8AD2-406D-9F37-33740F86FC59@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/10 10:26, Mathias Krause wrote:
> On 29.11.2010, 17:31 Randy Dunlap wrote:
>> On Mon, 29 Nov 2010 14:03:35 +1100 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20101126:
>>
>>
>> on i386 builds, I get tons of these (and more) errors:
>>
>> arch/x86/crypto/aesni-intel_asm.S:841: Error: bad register name `%r12'
>> arch/x86/crypto/aesni-intel_asm.S:842: Error: bad register name `%r13'
>> arch/x86/crypto/aesni-intel_asm.S:843: Error: bad register name `%r14'
>> arch/x86/crypto/aesni-intel_asm.S:844: Error: bad register name `%rsp'
>> arch/x86/crypto/aesni-intel_asm.S:849: Error: bad register name `%rsp'
>> arch/x86/crypto/aesni-intel_asm.S:850: Error: bad register name `%rsp'
>> arch/x86/crypto/aesni-intel_asm.S:851: Error: bad register name `%r9'
>>
>> even though the kernel .config file says:
>>
>> CONFIG_CRYPTO_AES=m
>> CONFIG_CRYPTO_AES_586=m
>> CONFIG_CRYPTO_AES_NI_INTEL=m
>>
>> Should arch/x86/crypto/aesni-intel_asm.S be testing
>> #ifdef CONFIG_X86_64
>> instead of
>> #ifdef __x86_64__
>> or does that not matter?
>>
>> or is this a toolchain issue?
> 
> Well, __x86_64__ should be a build-in define of the compiler while
> CONFIG_X86_64 is defined for 64 bit builds in include/generated/autoconf.h.
> So by using the latter we should be on the safe side but if your compiler
> defines __x86_64__ for 32-bit builds it's simply broken. Also git grep
> showed quite a few more places using __x86_64__ so those would miscompile on
> your toolchain, too.
> 
> But it looks like linux-next is just missing
> 559ad0ff1368baea14dbc3207d55b02bd69bda4b from Herbert's git repo at
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git.
> That should fix the build issue.

The build problem still happens when that patch is applied.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
