Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab0I3Rjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 13:39:52 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38872 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab0I3Rjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 13:39:51 -0400
Date: Thu, 30 Sep 2010 18:39:45 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, joerg.roedel@amd.com, jbarnes@virtuousgeek.org
Subject: Re: [PATCH] pci: Reenable the AMD IOMMU if it's mysteriously
	vanished over suspend
Message-ID: <20100930173945.GA16596@srcf.ucam.org>
References: <1285861108-24122-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285861108-24122-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 11:38:28AM -0400, Matthew Garrett wrote:
> AMD's reference BIOS code had a bug that could result in the firmware
> failing to reenable the iommu on resume. It transpires that this causes
> certain less than desirable behaviour when it comes to PCI accesses, to
> whit them ending up somewhere near Bristol when the more desirable outcome
> was Edinburgh. Sadness ensues, perhaps along with filesystem corruption.
> Let's make sure that it gets turned back on.

Of course, this isn't actually sufficient - nothing in the iommu code 
appears to reprogram the BAR, for instance. Joerg, how is this meant to 
work?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
