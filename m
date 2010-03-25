Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab0CYQCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 12:02:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34282 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750938Ab0CYQCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:02:45 -0400
Date: Thu, 25 Mar 2010 16:06:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jesse.brandeburg@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
Message-ID: <20100325160612.23ab0263@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.1003251441420.3147@localhost.localdomain>
References: <20100324190150.GA18803@basil.fritz.box>
	<alpine.LFD.2.00.1003242125320.3147@localhost.localdomain>
	<alpine.LFD.2.00.1003250001500.3147@localhost.localdomain>
	<20100325003652.GG20695@one.firstfloor.org>
	<alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
	<20100325093744.GH20695@one.firstfloor.org>
	<alpine.LFD.2.00.1003251133010.3147@localhost.localdomain>
	<20100325121141.GO20695@one.firstfloor.org>
	<alpine.LFD.2.00.1003251338130.3147@localhost.localdomain>
	<20100325133204.GP20695@one.firstfloor.org>
	<alpine.LFD.2.00.1003251441420.3147@localhost.localdomain>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> Right now they happen with a weird test case which points out a
> trouble spot. Multi vector NICs under heavy load. So why not go there
> and change the handful of drivers to run their handlers with irqs
> disabled?

How about - because it can happen anyway ? It's merely a lot less likely
and if it is occuring at random in very obscure situations the chances
are it doesn't produce a nice neat report that it occurred either. Your
assertion that this is the only case it is seen appears unbacked by
evidence for or against.

> Band aids are the last resort if we can't deal with a problem by other
> sane means. And this problem falls not into that category, it can be
> solved in the affected drivers with zero effort.

Thomas - you can't complain about Andi's patches being inadequate and
then suggest an ever more incomplete 'solution'. Absolute minimum we need
to WARN() in that situation so that kerneloops.org can gather statistics
on what occurs and try to find out.

The real fix is not zero effort, as you yourself said there are quite a
few subsystems re-enabling interrupts in their IRQ paths and all would
need fixing.

Alan
