Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab0LAUJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 15:09:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56900 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab0LAUJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 15:09:20 -0500
Date: Wed, 1 Dec 2010 15:09:07 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Tejun Heo <tj@kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 2.6.37
Message-ID: <20101201200907.GI25668@bombadil.infradead.org>
References: <4CF506A6.4020200@kernel.org>
 <20101130153839.GM15818@bombadil.infradead.org>
 <4CF52652.4030802@kernel.org>
 <20101130163150.GA25668@bombadil.infradead.org>
 <20101130175317.GB25668@bombadil.infradead.org>
 <20101130210938.GF25668@bombadil.infradead.org>
 <4CF62EE0.7040607@kernel.org>
 <20101201124445.GG25668@bombadil.infradead.org>
 <4CF6595A.6010104@kernel.org>
 <20101201155026.GH25668@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201155026.GH25668@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 10:50:26AM -0500, Kyle McMartin wrote:
> > Nothing peculiar.  Hmm... okay, I think I've found what went wrong.
> > Can you please try the following patch and see whether the problem
> > goes away?
> > 
> 
> Thanks, I'll let you know when/if it drops to 1.5gbps.
> 

Looks to stay at 3.0 Gbps now... but gives up on EH after 5 retries?

[ 4342.048572] ata1: hard resetting link
[ 4342.507282] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 4342.510118] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4342.510127] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[ 4342.510413] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4342.510421] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[ 4342.514766] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4342.514774] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[ 4342.515024] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4342.515031] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[ 4342.516697] ata1.00: configured for UDMA/100
[ 4342.516977] ata1: hard resetting link
[ 4342.976018] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 4342.978892] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4342.978900] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[ 4342.979186] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4342.979193] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[ 4342.983577] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4342.983585] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[ 4342.983865] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4342.983872] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[ 4342.984989] ata1.00: configured for UDMA/100
[ 4342.985408] ata1: hard resetting link
[ 4343.445045] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 4343.447845] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4343.447856] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[ 4343.448119] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4343.448126] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[ 4343.451322] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4343.451330] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[ 4343.451628] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4343.451635] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[ 4343.452961] ata1.00: configured for UDMA/100
[ 4343.453269] ata1: hard resetting link
[ 4343.912801] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 4343.915808] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4343.915816] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[ 4343.916102] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4343.916110] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[ 4343.921403] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4343.921411] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[ 4343.921679] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4343.921686] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[ 4343.923580] ata1.00: configured for UDMA/100
[ 4343.923841] ata1: hard resetting link
[ 4344.383113] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 4344.386020] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4344.386029] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[ 4344.386309] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4344.386320] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[ 4344.390462] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4344.390470] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[ 4344.390737] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES)
succeeded
[ 4344.390744] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[ 4344.392217] ata1.00: configured for UDMA/100
[ 4344.392496] ata1: EH pending after 5 tries, giving up
[ 4344.392507] ata1: EH complete

regards, Kyle
