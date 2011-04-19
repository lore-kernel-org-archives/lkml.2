Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab1DSXJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 19:09:26 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:20144 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1DSXJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 19:09:25 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 19 Apr 2011 18:09:19 -0500
From: Scott Wood <scottwood@freescale.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <john.williams@petalogix.com>
Subject: Re: [PATCH v3] uio/pdrv_genirq: Add OF support
Message-ID: <20110419180919.17971598@schlenkerla.am.freescale.net>
In-Reply-To: <20110419220018.GB2772@local>
References: <1303116654-5042-1-git-send-email-monstr@monstr.eu>
	<20110419060816.GA5252@ponder.secretlab.ca>
	<20110419220018.GB2772@local>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 00:00:18 +0200
"Hans J. Koch" <hjk@hansjkoch.de> wrote:

> On Tue, Apr 19, 2011 at 12:08:16AM -0600, Grant Likely wrote:
> > PowerPC and x86 will return 0 for an unassigned IRQ, as will most platforms.
> 
> That might be right for these architectures. On ARM SoCs, IRQ0 is often a
> normal irq like any other (e.g. "Audio DMA Controller 1" on Telechips TCC8000).

It's true on at least some powerpc and x86 interrupt controllers as well.
ARM isn't special. :-)

I'm not sure what goes on on x86, as I see a real " 0:" in
/proc/interrupts.  But on powerpc, Linux's IRQ numberspace is decoupled
from that of any IRQ controller.  This is mainly to accommodate multiple
IRQ controllers with their own numberspaces in the same system; being able
to avoid irq 0 is just a bonus.

-Scott

