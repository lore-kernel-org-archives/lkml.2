Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab2DBEWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 00:22:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:58336 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab2DBEWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 00:22:31 -0400
Message-ID: <1333340517.30734.42.camel@pasglop>
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use
 irq_alloc_desc() instead
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Date: Mon, 02 Apr 2012 14:21:57 +1000
In-Reply-To: <m2iphj3zxr.fsf@igel.home>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
	 <1329383368-12122-7-git-send-email-grant.likely@secretlab.ca>
	 <m2iphj3zxr.fsf@igel.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-01 at 23:27 +0200, Andreas Schwab wrote:
> Grant Likely <grant.likely@secretlab.ca> writes:
> 
> > This patch drops the powerpc-specific irq_map table and replaces it with
> > directly using the irq_alloc_desc()/irq_free_desc() interfaces for allocating
> > and freeing irq_desc structures.
> 
> This breaks irqs on PowerMac G5.  I see lost irq errors from the sata
> driver.
> 
> Note that the breakage only started after the series was merged into
> mainline.  But when transplanted upon the parent of the merge this is
> the commit that was blamed by bisect.  So something changed between
> v3.3-rc3 and the merge of this series that broke it.

can you tell me more ? (What machine precisely, what .config etc...) ?

I tested here on two G5's:

 - PowerMac7,3 aka Dual G5 AGP. This ones has U3 + K2 and
uses cascaded MPICs

 - PowerMac11,2 aka Quad G5. This one has U4 + K2 and uses a single MPIC
in the northbridge

And both appear to work fine with today upstream (basically -rc1).

Cheers,
Ben.


