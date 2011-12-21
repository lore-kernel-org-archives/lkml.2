Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab1LUSsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:48:23 -0500
Received: from sous-sol.org ([216.99.217.87]:58607 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753033Ab1LUSsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:48:21 -0500
Date: Wed, 21 Dec 2011 10:48:11 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: "Hao, Xudong" <xudong.hao@intel.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] intel-iommu: Add device info into list before doing
 context mapping
Message-ID: <20111221184811.GC961@sequoia.sous-sol.org>
References: <BC00F5384FCFC9499AF06F92E8B78A9E2890486DD3@shsmsx502.ccr.corp.intel.com>
 <20111220160730.GD30205@sequoia.sous-sol.org>
 <BC00F5384FCFC9499AF06F92E8B78A9E28904879BF@shsmsx502.ccr.corp.intel.com>
 <20111221184108.GB961@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221184108.GB961@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Wright (chrisw@sous-sol.org) wrote:
> * Hao, Xudong (xudong.hao@intel.com) wrote:
> > Yes, Chris, thanks your comments.
> > How about this one?
> 
> Yes, it gets the locking right.

Sorry, I missed one other problem on the error path.  You need to also
update pdev->dev.archdata.iommu to NULL (otherwise it is left pointing
to freed memory).

> Also makes host device and guest assigned device go through the same order:
> 
> alloc_devinfo and init
> lock; place info on lists; unlock
> domain_context_mapping()
> 
> The patch itself is whitespace damaged and does not apply.  Please fix
> and feel free to add my:
> 
> Acked-by: Chris Wright <chrisw@sous-sol.org>
