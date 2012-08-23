Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934442Ab2HWU6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:58:50 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54655 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934358Ab2HWU6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:58:46 -0400
Date: Thu, 23 Aug 2012 22:58:40 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 02/19] [RFC] x86, apic: Mask IO-APIC and PIC
 unconditionally on LAPIC resume
Message-ID: <20120823205840.GA7120@breakpoint.cc>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-3-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345470965-24410-3-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 03:55:48PM +0200, Joerg Roedel wrote:
> IO-APIC and PIC use the same resume routines when IRQ
> remapping is enabled or disabled. So it should be safe to
> mask the other APICs for the IRQ-remapping-disabled case
> too.

So your point is that it works with irq-remapping so it should work without as
well.
The lapic code registers its opcodes as the first syscore device so this code
is always executed before the lapic's and pic resume code. PIC masks its sources
during init so it does not matter if they are masked earlier. And ioapic, well
it restores its entries as well.
So yes, I think this safe to do here.

Sebastian
