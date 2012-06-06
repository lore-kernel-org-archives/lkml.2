Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab2FFRmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:42:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45549 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2FFRmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:42:05 -0400
Date: Wed, 6 Jun 2012 18:42:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: linux-kernel@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] Disable Bus Master on PCI device shutdown
Message-ID: <20120606174202.GA8750@srcf.ucam.org>
References: <20120427190033.GA17588@ldl.usa.hp.com>
 <20120606135009.GB1517@srcf.ucam.org>
 <1338999463.25761.630.camel@lyra>
 <20120606162703.GA6779@srcf.ucam.org>
 <1339003956.25761.667.camel@lyra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339003956.25761.667.camel@lyra>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 11:32:36AM -0600, Khalid Aziz wrote:

> Do we agree that if device shutdown routine cleanly shuts down all I/O,
> clearing PCI Bus Mster bit should be safe?

In the absence of hardware that dislikes the bus master bit ever being 
disabled, yes. Do we know if hardware is ever tested in that situation?

> If yes, then we only have to deal with broken devices. So the approach 
> could be to disable Bus Master bit unless the device ID matches a 
> blacklist which we update as we find broken devices. I really don't 
> like the idea of maintaining blacklists in the kernel for such things 
> but is that a more practical approach? If blacklist does not sound 
> good, maybe we can ask drivers to tell PCI subsystem if they are not 
> ok with clearing Bus Master bit and then PCI subsystem could skip 
> those devices.

Or we could just put responsibility on the drivers to ensure that the 
hardware won't continue doing any DMA, either by shutting down the 
engines or clearing the bit.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
