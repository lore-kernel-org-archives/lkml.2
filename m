Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab2BPX1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 18:27:07 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52970 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab2BPX1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 18:27:05 -0500
Date: Thu, 16 Feb 2012 23:26:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v5 00/27] irq_domain generalization and rework
Message-ID: <20120216232648.GM27825@n2100.arm.linux.org.uk>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca> <20120216145219.0f1c1b98.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216145219.0f1c1b98.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 02:52:19PM -0800, Andrew Morton wrote:
> On Thu, 16 Feb 2012 02:09:01 -0700
> Grant Likely <grant.likely@secretlab.ca> wrote:
> > This series generalizes the "irq_host" infrastructure from powerpc
> > so that it can be used by all architectures and renames it to "irq_domain".
> 
> drivers/mfd/twl-core.c is fairly horked on i386 allmodconfig:
> 
> drivers/mfd/twl-core.c: In function 'twl_probe':
> drivers/mfd/twl-core.c:1218: error: implicit declaration of function 'irq_alloc_descs'
> drivers/mfd/twl-core.c:1226: error: implicit declaration of function 'irq_domain_add_legacy'
> drivers/mfd/twl-core.c:1227: error: 'irq_domain_simple_ops' undeclared (first use in this function)
> drivers/mfd/twl-core.c:1227: error: (Each undeclared identifier is reported only once
> drivers/mfd/twl-core.c:1227: error: for each function it appears in.)
> 
> This is today's linux-next so it has rmk's "ARM: omap: fix broken
> twl-core dependencies and ifdefs" in there, which looks like it
> attempts to repair this stuff.

Yes, you're the third to report this breakage.

Grant's response on Tuesday over this was:
| This is irq_domain related.  It's related to an API change.  I'm
| tracking to get it solved, either by moving the twl commit into the
| irqdomain branch or by deferring the api change to v3.5.
|
| I've also got a patch that converts x86 over to the new api, but I
| don't have sufficient review to put it into the irqdomain tree yet.

> btw, Russell, regarding this comment in include/linux/irq.h:
> 
> /*
>  * Please do not include this file in generic code.  There is currently
>  * no requirement for any architecture to implement anything held
>  * within this file.
>  *
>  * Thanks. --rmk
>  */
> 
> A quick grep indicates that we've lost this battle ;) Is the comments
> still true?  Should we stop discouraging inclusion of linux/irq.h? 
> Does anyone even know that it's discouraged ;)

It's still true for any platform which hasn't been converted to genirq,
as such a platform would not have asm/hw_irq.h.  That said, since
genirq, it's now necessary for any driver which contains interrupt
controller code like GPIO drivers.  So I suspect the comment should now
be lost, even though it's not really a replacement for asm/irq.h.
