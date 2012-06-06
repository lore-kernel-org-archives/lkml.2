Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab2FFUKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:10:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53780 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab2FFUKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:10:06 -0400
Date: Wed, 6 Jun 2012 21:09:46 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Khalid Aziz <khalid.aziz@hp.com>, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, linux-pci@vger.kernel.org
Subject: Re: [PATCH] Disable Bus Master on PCI device shutdown
Message-ID: <20120606200946.GA11946@srcf.ucam.org>
References: <20120427190033.GA17588@ldl.usa.hp.com>
 <20120606135009.GB1517@srcf.ucam.org>
 <1338999463.25761.630.camel@lyra>
 <20120606162703.GA6779@srcf.ucam.org>
 <1339003956.25761.667.camel@lyra>
 <20120606174202.GA8750@srcf.ucam.org>
 <1339006060.25761.689.camel@lyra>
 <87obowxm5s.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87obowxm5s.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 12:42:07PM -0700, Eric W. Biederman wrote:

> pci_device_shutdown calls drv->shutdown before calling
> pci_device_disable.  Which means that only devices that have trouble
> with this bit being flipped while DMA is ongoing and don't bother
> to stop their own DMA will have a problem.

drv->shutdown should already be quiescing the hardware. If it isn't, it 
should be. If it is, what does this patch fix? Many drivers 
call pci_enable_device() early enough that they clearly expect the 
hardware to be quiescent when they do so, so this really does seem to 
simply handle the kexec case without handling any other cases that could 
be similarly problematic.                               

-- 
Matthew Garrett | mjg59@srcf.ucam.org
