Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2IXIf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:35:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38627 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab2IXIf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:35:56 -0400
Date: Mon, 24 Sep 2012 09:35:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chanho Min <chanho0207@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: gic: fix irq affinity mismatch.
Message-ID: <20120924083530.GM15609@n2100.arm.linux.org.uk>
References: <CAOAMb1DEKrgjtq-xRB+Qy1+_8D-G+6g2v9QSLMisVNbKa8+jSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOAMb1DEKrgjtq-xRB+Qy1+_8D-G+6g2v9QSLMisVNbKa8+jSA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 12:06:19PM +0900, Chanho Min wrote:
> Even if we set affinity to multiple cpus via procfs, gic_set_affinity
> allows to set one target only. But, '/proc/irq/xxx/smp_affinity' shows
> as we are successful in the setting of multiple affinity. Thus irq_data->
> affinity mismatches with the GICD_ITARGETSRs.
> 
> fix it as bellows.
> - Set the default affinity to the boot cpu in gic_dist_init. thereafter,
> irq_data->affinity will be set to default 1-bit affinity.
> - Even if we write multiple bits to smp_affinity, both irq_data and gic
> register will be set one cpu. procfs will show 1 bit affinity as well.

This has come up before.  There is no requirement to make the affinity
mask reflect back to userspace what the hardware is doing.  So, NAK.
