Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab1HYPWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:22:22 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:26422 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab1HYPWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:22:19 -0400
X-SpamScore: -22
X-BigFish: VS-22(zz146fK1447R1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4E56689D.3080202@freescale.com>
Date: Thu, 25 Aug 2011 10:22:05 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build failure after merge of the final tree (tty
 tree related)
References: <20110825161843.daf46b6b4023926fcfeec387@canb.auug.org.au> <20110825140820.GA9126@kroah.com>
In-Reply-To: <20110825140820.GA9126@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> > MSR_GS is defined in arch/powerpc/include/asm/reg_booke.h which is
>> > included by arch/powerpc/include/asm/reg.h but only when defined
>> > (CONFIG_BOOKE) || defined(CONFIG_40x).
> Thanks for the report.
> 
> Timur, care to send a fixup patch for this so this gets resolved?

Is there some trick to building allyesconfig on PowerPC?  When I do try that, I
get all sorts of weird build errors, and it dies long before it gets to my
driver.  I get stuff like:

  LD      arch/powerpc/sysdev/xics/built-in.o
WARNING: arch/powerpc/sysdev/xics/built-in.o(.text+0x1310): Section mismatch in
reference from the function .icp_native_init() to the function
.init.text:.icp_native_init_one_node()
The function .icp_native_init() references
the function __init .icp_native_init_one_node().
This is often because .icp_native_init lacks a __init
annotation or the annotation of .icp_native_init_one_node is wrong.

and

  AS      arch/powerpc/kernel/head_64.o
arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
arch/powerpc/kernel/exceptions-64s.S:1151: Error: attempt to move .org backwards
arch/powerpc/kernel/exceptions-64s.S:1160: Error: attempt to move .org backwards
make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1

I guess I don't have the right compiler.

Anyway, I think I know how to fix the break that Stephen is seeing.  I will post
a v4 patch in a few minutes.


-- 
Timur Tabi
Linux kernel developer at Freescale

