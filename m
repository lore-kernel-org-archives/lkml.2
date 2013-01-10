Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab3AJRJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:09:48 -0500
Received: from 8bytes.org ([85.214.48.195]:56071 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab3AJRJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:09:47 -0500
Date: Thu, 10 Jan 2013 18:09:43 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH] iommu: moving initialization earlier
Message-ID: <20130110170941.GA2556@8bytes.org>
References: <1357545112-17375-1-git-send-email-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357545112-17375-1-git-send-email-aik@ozlabs.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jan 10 18:09:44 2013
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50eef5d822971253774753
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 06:51:52PM +1100, Alexey Kardashevskiy wrote:
> The iommu_init() initializes IOMMU internal structures and data
> required for the IOMMU API as iommu_group_alloc().
> It is registered as a subsys_initcall now.
> 
> One of the IOMMU users is going to be a PCI subsystem on POWER.
> It discovers new IOMMU tables during the PCI scan so the logical
> place to call iommu_group_alloc() is the moment when a new group
> is discovered. However PCI scan is done from subsys_initcall hook
> as IOMMU does so PCI hook can be (and is) called before the IOMMU one.
> 
> The patch moves IOMMU subsystem initialization one step earlier
> to make sure that IOMMU is initialized before PCI scan begins.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Applied, thanks.


