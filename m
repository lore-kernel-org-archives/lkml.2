Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab2ITTjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 15:39:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58864 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095Ab2ITTje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 15:39:34 -0400
Date: Thu, 20 Sep 2012 20:39:26 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [RFC 3/3] PCI/PM: Disable PME poll for PCIe devices
Message-ID: <20120920193926.GA6623@srcf.ucam.org>
References: <1347872076-5260-1-git-send-email-ying.huang@intel.com>
 <1347872076-5260-4-git-send-email-ying.huang@intel.com>
 <201209202131.13483.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209202131.13483.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 09:31:13PM +0200, Rafael J. Wysocki wrote:
> On Monday, September 17, 2012, Huang Ying wrote:
> > PME poll is not necessary for PCIe devices, because PCIe devices use
> > in-band PME message and IRQ on PCIe port to report PME.
> 
> Alas, not all of them as it turns out and even if they do, it doesn't
> work for some of them. That's why we've added the PCIe devices polling
> (quite recently, for that matter).

Right. I'd believe that there's some underlying bug that's causing the 
missing PMEs and maybe it does work in theory, but the reality is that 
right now some PCIe devices are not getting their PMEs delivered to us. 
We don't know if it's our bug or a hardware bug, and until we do we need 
to leave the polling code.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
