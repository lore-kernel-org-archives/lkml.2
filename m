Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab2DSScC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:32:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36619 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab2DSScA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:32:00 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: irq_domain fixes for v3.4-rc2
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <m27gxjnaou.fsf@igel.home>
References: <1334186326-22649-1-git-send-email-grant.likely@secretlab.ca> <m27gxjnaou.fsf@igel.home>
Date: Thu, 19 Apr 2012 12:31:57 -0600
Message-Id: <20120419183157.EC9543E0700@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012 13:16:49 +0200, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Grant Likely <grant.likely@secretlab.ca> writes:
> 
> > I've pushed this out to the following branch for testing:
> >
> > git://git.secretlab.ca/git/linux-2.6 irqdomain/test
> 
> That doesn't work at all.  I get a warning in virq_to_hw and it hangs
> later, probably during SMP bringup due to lost IPI interrupts.

There are a bunch of bugs in the MPIC driver that Ben discovered that
only work because it just happens to be that hwirq == virq.  Removing
the hint breaks the driver badly.  I've backed off from that change
and instead just merged the NR_IRQS fix.  After the MPIC bugs are
fixed I want to revisit removing the hint.

g.

