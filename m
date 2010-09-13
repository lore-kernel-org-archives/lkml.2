Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0IMMxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 08:53:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38555 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab0IMMxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 08:53:18 -0400
Date: Mon, 13 Sep 2010 13:53:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Robin Theunis <robint91@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-embedded mailing list <linux-embedded@vger.kernel.org>
Subject: Re: ARM target not boot after remap memory
Message-ID: <20100913125310.GI30787@n2100.arm.linux.org.uk>
References: <AANLkTi=tWwaFHB0DY=j0UaqbYdYJpGJpmWdGC4aMufSw@mail.gmail.com> <4C8E1417.4060204@compulab.co.il> <20100913124049.GG30787@n2100.arm.linux.org.uk> <AANLkTi=dT1uMrRctB4=Hvh35zVc-DtReWmHj-18cd9XT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=dT1uMrRctB4=Hvh35zVc-DtReWmHj-18cd9XT@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, Please do not drop CCs.

On Mon, Sep 13, 2010 at 02:48:18PM +0200, Robin Theunis wrote:
> Hi Russell,
> 
> Yes I have tested it. I made a breakpoint at 0x2008000 and viewed that
> the r1 register and there in I found the correct ID.
> 
> Robin
> 
> 2010/9/13 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> > On Mon, Sep 13, 2010 at 02:07:51PM +0200, Mike Rapoport wrote:
> >> (add LAKLM to CC)
> >
> >>> The problem is now when linux kernel is booting, nothing happens.
> >>>
> >>> ---
> >>> U-Boot> bootm
> >>> ## Booting kernel from Legacy Image at 21000000 ...
> >>>    Image Name:   Linux-2.6.34.1robin9200v1.0
> >>>    Image Type:   ARM Linux Kernel Image (uncompressed)
> >>>    Data Size:    1811796 Bytes = 1.7 MiB
> >>>    Load Address: 20008000
> >>>    Entry Point:  20008000
> >>>    Verifying Checksum ... OK
> >>>    Loading Kernel Image ... OK
> >>> OK
> >>>
> >>> Starting kernel ...
> >>>
> >>> Uncompressing Linux... done, booting the kernel.
> >>> ---
> >>>
> >>> Here is stalls. With my jtag probe I can locate the problem.
> >>>
> >>> ---
> >>>> halt
> >>> target state: halted
> >>> target halted in ARM state due to debug-request, current mode: Supervisor
> >>> cpsr: 0x600000d3 pc: 0xc000af3c
> >>> MMU: enabled, D-Cache: enabled, I-Cache: enabled
> >>>>   arm disassemble 0xc000af3c
> >>> 0xc000af3c   0xeafffffe      B 0xc000af3c
> >
> > Probably __error.  Either your machine isn't supported, or the kernel
> > doesn't recognise your processor.
> >
> > Is your version of uboot sufficiently recent that it passes the correct
> > machine ID in r1 ?
> >
