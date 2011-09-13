Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1IMO7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:59:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab1IMO7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:59:00 -0400
Date: Tue, 13 Sep 2011 16:58:55 +0200
From: Greg KH <gregkh@suse.de>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Joerg Roedel <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Message-ID: <20110913145855.GA4581@suse.de>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
 <1315410113-26608-3-git-send-email-joerg.roedel@amd.com>
 <20110907184750.GA920@suse.de>
 <20110907191919.GA31674@8bytes.org>
 <20110907194445.GA2526@suse.de>
 <20110913145402.GM11701@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110913145402.GM11701@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 04:54:02PM +0200, Roedel, Joerg wrote:
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -22,6 +22,7 @@
>  #include <linux/types.h>
>  #include <linux/module.h>
>  #include <linux/pm.h>
> +#include <linux/iommu.h>

Ick, please don't add new #includes to device.h, it makes the whole
build slower.  Just pre-declare the structure and all should be fine.

Don't you need to also redo the other patches in this series based on
the other comments you received?

greg k-h
