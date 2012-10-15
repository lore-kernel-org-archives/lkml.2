Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab2JOHad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:30:33 -0400
Received: from smtp1.uu.se ([130.238.7.54]:33163 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab2JOHab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 03:30:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20603.47887.262025.941051@pilspetsen.it.uu.se>
Date: Mon, 15 Oct 2012 09:28:15 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Yangfei (Felix)" <felix.yang@huawei.com>
Cc: "linux-assembly@vger.kernel.org" <linux-assembly@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Hardcoded instruction causes certain features to fail on ARM
 platfrom due to endianness
In-Reply-To: <DA41BE1DDCA941489001C7FBD7A8820E3CB407A4@szxeml549-mbx.china.huawei.com>
References: <DA41BE1DDCA941489001C7FBD7A8820E3CB407A4@szxeml549-mbx.china.huawei.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yangfei (Felix) writes:
 > Hi all,
 > 
 >     I found that hardcoded instruction in inline asm can cause certains certain features fail to work on ARM platform due to endianness.
 >     As an example, consider the following code snippet of platform_do_lowpower function from arch/arm/mach-realview/hotplug.c:
 >                 / *
 >                  * here's the WFI
 >                  */
 >                 asm(".word      0xe320f003\n"
 >                     :
 >                     :
 >                     : "memory", "cc");
 > 
 >     The instruction generated from this inline asm will not work on big-endian ARM platform, such as ARM BE-8 format. Instead, an exception will be generated.
 > 
 >     Here the code should be:
 >                 / *
 >                  * here's the WFI
 >                  */
 >                 asm("WFI\n"
 >                     :
 >                     :
 >                     : "memory", "cc");
 > 
 >     Seems the kernel doesn't support ARM BE-8 well. I don't know why this problem happens.
 >     Can anyone tell me who owns this part? I can prepare a patch then. 
 >     Thanks.

Questions regarding the ARM kernel should go to the linux-arm-kernel mailing list
(see the MAINTAINERS file), with an optional cc: to the regular LKML.

BE-8 is, if I recall correctly, ARMv7's broken format where code and data have
different endianess.  GAS supports an ".inst" directive which is like ".word"
except the data is assumed to be code.  This matters for disassembly, and may
also be required for BE-8.

That is, just s/.word/.inst/g above and report back if that works or not.
