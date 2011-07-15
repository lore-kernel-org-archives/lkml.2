Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab1GOUOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 16:14:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40034 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab1GOUOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 16:14:18 -0400
Date: Fri, 15 Jul 2011 14:14:14 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        tglx@linutronix.de
Subject: Re: [PATCH v4] pch_gpio: Support interrupt function
Message-ID: <20110715201414.GK2833@ponder.secretlab.ca>
References: <1309486572-2789-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <20110704163137.GA28042@ponder.secretlab.ca>
 <4E128A7D.9020508@dsn.okisemi.com>
 <20110705035902.GB13713@ponder.secretlab.ca>
 <4E12A69C.8030709@dsn.okisemi.com>
 <4E1AB3F7.2070600@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1AB3F7.2070600@dsn.okisemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 05:27:35PM +0900, Tomoya MORINAGA wrote:
> Hi Grant,
> 
> (2011/07/05 14:52), Tomoya MORINAGA wrote:
> >(2011/07/05 12:59), Grant Likely wrote:
> >>>As we discussed before,
> >>>without specifying PCH_IRQ_BASE,
> >>>it seemed IRQ number collision issue occurred.
> >>>Thus, I added PCH_IRQ_BASE.
> >>
> >>Then fix the irq collision. If the core code hands out an irq range
> >>that is in-use by some other driver, then the other driver isn't
> >>reserving it's irqs correctly and it needs to be fixed. Hacking
> >>around the problem doesn't help anything in the long run.
> >>
> >
> >I tried to work irq_alloc_descs with dynamic allocation.(Set 2nd
> >parameter as 0).
> >However it seems the issue remains to be seen.
> >I attached dmesg output log, /proc/interrupts log and modified PCH-GPIO
> >source code.
> >
> >Could you give me your opinion or information ?
> >
> >NOTE: I tested on linux-3.0-rc3
> >
> How is it going ?

Sounds like the platform is not correctly reserving the irq descs it
is using.  You'll need to dig into the irq desc allocation code to
debug it.

g.

