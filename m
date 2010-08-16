Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0HPKca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 06:32:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:58845 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab0HPKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 06:32:29 -0400
Subject: Re: [PATCH] [MTD] [NAND] pxa3xx: fix ns2cycle equation
From: David Woodhouse <dwmw2@infradead.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Reimer <mreimer@vpop.net>, Eric Miao <eric.y.miao@gmail.com>,
        linux-mtd@lists.infradead.org
In-Reply-To: <1281946149.10299.1.camel@mola>
References: <1281946149.10299.1.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 11:32:18 +0100
Message-ID: <1281954738.21549.65.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 16:09 +0800, Axel Lin wrote:
> Test on a PXA310 platform with Samsung K9F2G08X0B NAND flash,
> with tCH=5 and clk is 156MHz, ns2cycle(5, 156000000) returns -1.
> 
> ns2cycle returns negtive value will break NDTR0_tXX macros.
> 
> After checking the commit log, I found the problem is introduced by
> commit 5b0d4d7c8a67c5ba3d35e6ceb0c5530cc6846db7
> "[MTD] [NAND] pxa3xx: convert from ns to clock ticks more accurately"
> 
> To get num of clock cycles, we use below equation:
> num of clock cycles = time (ns) / one clock cycle (ns) + 1
> We need to add 1 cycle here because integer division will truncate the result.
> It is possible the developers set the Min values in SPEC for timing settings.
> Thus the truncate may cause problem, and it is safe to add an extra cycle here.
> 
> The various fields in NDTR{01} are in units of clock ticks minus one,
> thus we should subtract 1 cycle then.
> 
> Thus the correct equation should be:
> num of clock cycles = time (ns) / one clock cycle (ns) + 1 - 1
>                     = time (ns) / one clock cycle (ns)

Looks sane to me; thanks. Wants to go to stable@ too, yes?

Can I have an Acked-By: from Matt and/or Eric?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

