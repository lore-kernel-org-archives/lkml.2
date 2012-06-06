Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab2FFQ1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:27:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36549 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2FFQ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:27:07 -0400
Date: Wed, 6 Jun 2012 17:27:04 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: linux-kernel@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] Disable Bus Master on PCI device shutdown
Message-ID: <20120606162703.GA6779@srcf.ucam.org>
References: <20120427190033.GA17588@ldl.usa.hp.com>
 <20120606135009.GB1517@srcf.ucam.org>
 <1338999463.25761.630.camel@lyra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338999463.25761.630.camel@lyra>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 10:17:43AM -0600, Khalid Aziz wrote:

> That is a good piece of information. I see your concern and agree with
> it. My take is shutdown method for the drivers will end all active I/O
> and clear the I/O queue. This should take care of any DMA caused by an
> I/O request originating in the kernel. For devices like NIC, a DMA can
> be triggered by an incoming packet and I am trying to stop that by
> disabling Bus Master bit. This is the issue that was reported on kexec
> mailing list in July of last year and it involved qla driver. I observed
> similar problem with kexec on ia64 many years ago and had written a
> patch to disable Bus Master bit on kexec. This patch was in ia64 tree
> for some time before it was removed. HP shipped kernels with this patch
> for many years and those kernels have been in deployment in field for
> some 7+ years with no problems.

If the qla driver knows that this is safe, then can't this just be done 
in the qla driver?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
