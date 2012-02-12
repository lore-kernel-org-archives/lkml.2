Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab2BLU1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 15:27:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51318 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab2BLU1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 15:27:34 -0500
Date: Sun, 12 Feb 2012 20:27:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: Cleanup headers files
Message-ID: <20120212202728.GR23916@ZenIV.linux.org.uk>
References: <20120130192552.GL23916@ZenIV.linux.org.uk>
 <1328311063-17630-1-git-send-email-richard@nod.at>
 <20120204001431.GY23916@ZenIV.linux.org.uk>
 <4F2C7F7A.1090605@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2C7F7A.1090605@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 01:44:42AM +0100, Richard Weinberger wrote:
> Am 04.02.2012 01:14, schrieb Al Viro:
> > On Sat, Feb 04, 2012 at 12:17:43AM +0100, Richard Weinberger wrote:
> >> Many header files can be replaced by generic variants.
> > 
> > Umm...  I suspect that for auxvec.h the right thing is to simply
> > remove it - it's never used on uml builds.
> > 
> > FWIW, I've rebased my local queue to current and pushed it to kernel.org
> > again; it's on git.kernel.org/pub/scm/linux/kernel/git/viro/um-headers.git
> 
> So, I pulled your work and merged it into my shiny new UML tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git

Hmm...  I would really, really recommend you to clean the git history in that
tree up.  As it is, you have
	* merge of that branch from um-headers
	* um: Switch to large mcmodel on x86_64
	* um: Serve io_remap_pfn_range()
	* 205 merges from Linus, from mid-April to late January.
	* mismerge from Linus on April 14; the diff between the result
of that merge and its mainline parent is
diff --git a/drivers/platform/x86/intel_pmic_gpio.c b/drivers/platform/x86/intel_pmic_gpio.c
index 753bdb3..464bb3f 100644
--- a/drivers/platform/x86/intel_pmic_gpio.c
+++ b/drivers/platform/x86/intel_pmic_gpio.c
@@ -208,8 +208,8 @@ static struct irq_chip pmic_irqchip = {
        .name                   = "PMIC-GPIO",
        .irq_mask               = pmic_irq_mask,
        .irq_unmask             = pmic_irq_unmask,
-       .irq_set_type = pmic_irq_type, <<<<<<< HEAD
-       .irq_bus_lock           = pmic_irq_buslock,
+       .irq_set_type           = pmic_irq_type,
+       .irq_bus_lock           = pmic_bus_lock,
        .irq_bus_sync_unlock    = pmic_bus_sync_unlock,
 };
and that mangling is still in your tree
	* a bunch of cherry-picked (or manually applied?) commits from
mainline, done on April 12-13
	* 23 more backmerges
	* a _lot_ of cherry-picks circa March 12
	* 91 more backmerges
	* backmerge with a conflict; note that result of merge is identical
to the mainline parent of it (August 2010)
	* 5 more backmerges (once a week or so)
	* your "um: call free_irq() only on enabled channels", applied by
Linus (over mail, presumably) a couple of weeks later
	* 7 more backmerges
	* your variant of removal of unused variable in apic/es7000_32.c;
that's what caused conflict resolved by Aug 2010 merge.

As it is, you have mainline with mangled intel_pmic_gpio.c plus two recent
um commits plus the merge from um-headers.  _Please_, replace that with
mainline + the same two commits + merge.  And don't do the compulsive
backmerging like that...
