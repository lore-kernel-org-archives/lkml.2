Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1CUPss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 11:48:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36633 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1CUPso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 11:48:44 -0400
Date: Mon, 21 Mar 2011 15:48:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nguyen Dinh-R00091 <R00091@freescale.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "arnaud.patard@rtp-net.org" <arnaud.patard@rtp-net.org>,
        Vaidyanathan Ranjani-RA5478 <RA5478@freescale.com>,
        Zhang Lily-R58066 <R58066@freescale.com>,
        "festevam@gmail.com" <festevam@gmail.com>
Subject: Re: [PATCHv4 3/3] ARM: mx51: Add support for low power suspend on
	MX51
Message-ID: <20110321154833.GD4340@n2100.arm.linux.org.uk>
References: <1300461684-21775-1-git-send-email-Dinh.Nguyen@freescale.com> <1300461684-21775-2-git-send-email-Dinh.Nguyen@freescale.com> <1300461684-21775-3-git-send-email-Dinh.Nguyen@freescale.com> <20110318152502.GO29758@n2100.arm.linux.org.uk> <56132A77AB93C141BF06E6B96CA6CFEA1BC0AF@039-SN1MPN1-004.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56132A77AB93C141BF06E6B96CA6CFEA1BC0AF@039-SN1MPN1-004.039d.mgd.msft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 02:53:21PM +0000, Nguyen Dinh-R00091 wrote:
> >On Fri, Mar 18, 2011 at 10:21:24AM -0500, Dinh.Nguyen@freescale.com wrote:
> >> +#include <linux/suspend.h>
> >> +#include <linux/clk.h>
> >> +#include <asm/mach/map.h>
> >> +#include <asm/cacheflush.h>
> >> +#include <asm/tlb.h>
> >> +#include <mach/system.h>
> >> +#include "crm_regs.h"
> >
> >Why does the code below require asm/mach/map.h ?
> 
> map.h can be replaced by linux/io.h for the __raw_writel().
> 
> >Why does it require asm/tlb.h ?
> 
> asm/tlb is for the local_flush_tlb_all() call.

I think you want asm/tlbflush.h rather than the tlb shootdown stuff in
asm/tlb.h.

