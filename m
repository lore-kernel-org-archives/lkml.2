Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1HFPaW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 11:30:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36020 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1HFPaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 11:30:21 -0400
Date: Sat, 6 Aug 2011 16:30:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mel Gorman <mgorman@suse.de>, tglx@linutronix.de, hpa@zytor.com,
        bruno@ioda-net.ch, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Add reboot quirk for Dell Precision M4600
Message-ID: <20110806153003.GA1238@srcf.ucam.org>
References: <20110727125651.GH3010@suse.de>
 <20110806065635.GE13220@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110806065635.GE13220@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 06, 2011 at 08:56:35AM +0200, Ingo Molnar wrote:
> Weird - ACPI is the default Windows method of reboot - how come it 
> does not work on that box? Does Windows work around this specific 
> machine (unlikely), or is our ACPI boot sequence not 100% compatible 
> with the Windows method (more likely IMO)?

The ACPI reboot method on these machines hits the keyboard controller 
rather than PCI, which is unusual. What I suspect is that the write 
triggers some SMM or EC code that's making assumptions about system 
state, and we're not quite identical. Bouncing on the keyboard 
controller from userspace with init=/bin/bash wedges in the same way.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
