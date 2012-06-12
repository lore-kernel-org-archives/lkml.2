Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab2FLSZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:25:24 -0400
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:44915 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab2FLSZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:25:22 -0400
Message-ID: <20120612212518.22246qw5kuyn2osg@www.81.fi>
Date: Tue, 12 Jun 2012 21:25:18 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: aes - make assembler implementation default
 for i386 and x86-64
References: <20120530215333.32995tjzj9dr4jwo@www.81.fi>
 <20120609145055.12766.42439.stgit@localhost6.localdomain6>
 <20120612082651.GA13419@gondor.apana.org.au>
In-Reply-To: <20120612082651.GA13419@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Herbert Xu <herbert@gondor.apana.org.au>:

> On Sat, Jun 09, 2012 at 05:50:55PM +0300, Jussi Kivilinna wrote:
>> AES is often built-in and therefore implementations other than aes-generic
>> don't get autoloaded by module-aliases. This is solved for aes-ni by cpuid
>> autoloading, but for x86-64/i586 assembler implementation cpuid matching
>> does not make much sense (aes-generic built-in but overridden by x86-64/i586
>> assembler implementation module). Instead change Kconfig so that assembler
>> implementation is default on x86-64 and i386.
>>
>> This patch also splits common parts exported to assembler implementations
>> from aes-generic to new module aes-common.
>>
>> Patch tested on x86-64, compile tested on i386 and arm.
>>
>> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>
> I like the idea but I'm not sure about where we draw the line.
> E.g., why not enable padlock, or for that matter every single
> hardware implementation of AES?
>
> This can get unwieldy very quickly.
>

Well, how about letting arch specific assembler implementations  
replace aes-generic
completely.. in this case add "depends on !X86" on CRYPTO_AES_GENERIC.  
Hardware
modules get autoloaded (cpuid/pci/platform/etc) but generic assembler  
implementation
might as well be replacement as it cannot autoload depending on  
hardware support (or
it can, but will be always loaded).

-Jussi


