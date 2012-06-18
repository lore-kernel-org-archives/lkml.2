Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab2FRS5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 14:57:55 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:54729 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab2FRS5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 14:57:54 -0400
Date: Tue, 19 Jun 2012 00:27:48 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bug.h: Fix up powerpc build regression.
Message-ID: <20120618185747.GA727@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20120618045417.GB19803@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120618045417.GB19803@linux-sh.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12061808-6102-0000-0000-000001B68942
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Mundt <lethal@linux-sh.org> [2012-06-18 13:54:17]:

> The asm-generic/bug.h __ASSEMBLY__ guarding is completely bogus, which
> tripped up the powerpc build when the kernel.h include was added:
> 
> 	In file included from include/asm-generic/bug.h:5:0,
> 			 from arch/powerpc/include/asm/bug.h:127,
> 			 from arch/powerpc/kernel/head_64.S:31:
> 	include/linux/kernel.h:44:0: warning: "ALIGN" redefined [enabled by default]
> 	include/linux/linkage.h:57:0: note: this is the location of the previous definition
> 	include/linux/sysinfo.h: Assembler messages:
> 	include/linux/sysinfo.h:7: Error: Unrecognized opcode: `struct'
> 	include/linux/sysinfo.h:8: Error: Unrecognized opcode: `__kernel_long_t'
> 
> Moving the __ASSEMBLY__ guard up and stashing the kernel.h include under
> it fixes this up, as well as covering the case the original fix was
> attempting to handle.
> 
> Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
>
Tested-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

This build fix works fine for me for powerpc (pseries).

--Vaidy

