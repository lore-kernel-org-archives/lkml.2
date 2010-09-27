Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450Ab0I0N5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:57:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42006 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab0I0N5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:57:46 -0400
Date: Mon, 27 Sep 2010 14:57:35 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: Linux Power Management List <linux-pm@lists.osdl.org>,
        linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] intel_idle: PCI quirk to prevent Lenovo Ideapad s10-3
	boot hang
Message-ID: <20100927135735.GA856@srcf.ucam.org>
References: <alpine.LFD.2.00.1009242122390.8641@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009242122390.8641@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 09:26:31PM -0400, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> When the Lenovo Ideapad S10-3 is booted with HT enabled,
> it hits a boot hang in the intel_idle driver.
> 
> This occurs when entering ATM-C4 for the first time,
> unless BM_STS is first cleared.
> 
> acpi_idle doesn't see this because it first checks
> and clears BM_STS, but it would hit the same hang
> if that check were disabled.

If there's hardware that expects BM_STS to be cleared, and if we've 
previously always cleared BM_STS, shouldn't intel_idle be doing the same 
thing?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
