Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab0K2Qcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:32:35 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53631 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0K2Qce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:32:34 -0500
Date: Mon, 29 Nov 2010 08:31:05 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Huang Ying <ying.huang@intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>, linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for November 29 (aesni-intel)
Message-Id: <20101129083105.e202e922.randy.dunlap@oracle.com>
In-Reply-To: <20101129140335.19800705.sfr@canb.auug.org.au>
References: <20101129140335.19800705.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010 14:03:35 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101126:


on i386 builds, I get tons of these (and more) errors:

arch/x86/crypto/aesni-intel_asm.S:841: Error: bad register name `%r12'
arch/x86/crypto/aesni-intel_asm.S:842: Error: bad register name `%r13'
arch/x86/crypto/aesni-intel_asm.S:843: Error: bad register name `%r14'
arch/x86/crypto/aesni-intel_asm.S:844: Error: bad register name `%rsp'
arch/x86/crypto/aesni-intel_asm.S:849: Error: bad register name `%rsp'
arch/x86/crypto/aesni-intel_asm.S:850: Error: bad register name `%rsp'
arch/x86/crypto/aesni-intel_asm.S:851: Error: bad register name `%r9'

even though the kernel .config file says:

CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_AES_NI_INTEL=m

Should arch/x86/crypto/aesni-intel_asm.S be testing
#ifdef CONFIG_X86_64
instead of
#ifdef __x86_64__
or does that not matter?

or is this a toolchain issue?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
