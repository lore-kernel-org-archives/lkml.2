Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745Ab1KJIlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:41:51 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49494 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484Ab1KJIlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:41:50 -0500
Date: Thu, 10 Nov 2011 09:41:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: werner <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: 3.1 problem:  crash during boot
Message-ID: <20111110084144.GA1960@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, werner <w.landgraf@ru.ru>,
	linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
References: <web-642904662@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <web-642904662@zbackend1.aha.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 08:44:30PM -0400, werner wrote:
> A neihgbour's computer crashs with 3.1 , see below hand-copied from
> the screen.   More details are in the enclosed file.
> 
>

Hmm, this looks incomplete and is missing the oops header which says
exactly what happens.

Judging by the call stack below, it could be MTD maps something behind
CONFIG_MTD_ICHXROM, i.e. ichxrom_init_one() and below.

Adding MTD ML in case they've seen something similar already.

> c ...
> 1618067 genprobe_ident_chips+0x83/0x261
> 1f36808  ?_raw_write_unlock_irqrestore+0x6/0x1c
> 1589dfc  ? strnlen+0x3/0x1f
> 1b183c0   mtd_d0_chip_probe+0x17/0xa7
> 108bc8e  ? ftrace_test_stop_func+0x12/0x14
> 1b03aae  cfi_probe+0x12/0x14
> 1b03a84  do_map_probe+0x4a/0x62
> 1f3807d  ? trace+0x13/0x1b
> 1f09321  ichxrom_init_one+0x391/0x503
> 24fe1fg ? parse_early_options+0x25/0x25
> 254d98a   init_ichxrom+0x34/0x34
> 1001174   do_one_initall+0x8c/0x142
> 24fe1f9  ? parse_early_options+0x25/0x25
> 107f0d8  ? irq_to_desc+0x8/0x21
> 254d956  ? init_esb2rom+0x96/0x96
> 24fe1f9  ?  parse_early_options+0x25/0x25
> 24fc(or e)285  kernel_init+0x8c/0x120
> 1f38046 kernel_thread_helper+0x6/0x19

HTH.

-- 
Regards/Gruss,
   Boris
