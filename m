Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab0I3TFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:05:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56297 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab0I3TFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:05:42 -0400
Date: Thu, 30 Sep 2010 20:05:36 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        joerg.roedel@amd.com, jbarnes@virtuousgeek.org
Subject: Re: [PATCH] pci: Reenable the AMD IOMMU if it's mysteriously
	vanished over suspend
Message-ID: <20100930190536.GA18845@srcf.ucam.org>
References: <1285861108-24122-1-git-send-email-mjg@redhat.com> <20100930173945.GA16596@srcf.ucam.org> <20100930184301.GP15338@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930184301.GP15338@8bytes.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 08:43:01PM +0200, Joerg Roedel wrote:

> Enabling the IOMMU device is only part of what the BIOS is supposed to
> do to get the IOMMU ready for the OS. A handful of registers in the
> config space of the device and the IOMMU MMIO region must also be
> restored. Thats the simple part. The IOMMU device also spans two
> indirect register spaces to configure the IOMMU caches. I have no idea
> yet how this need to be configured. The plan is definitly to
> work-around a missing IOMMU device in the IOMMU driver. But I am still
> talking to some people to find out what exactly must be done, especially
> with the indirect register spaces.

Chapter 8 of the register setup guide seems to have something on this - 
I'll try saving and restoring all of the setup it performs to see if it 
improves things.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
