Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab1E1WLs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 18:11:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:48820 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab1E1WLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 18:11:45 -0400
Subject: Re: [PATCH] pci, dmar: Update dmar units devices list during hotplug
From: David Woodhouse <dwmw2@infradead.org>
To: Alex Williamson <alex.williamson@redhat.com>,
        Weidong Han <weidong.han@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        iommu@lists.linux-foundation.org,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 28 May 2011 23:11:35 +0100
In-Reply-To: <1306327429.3100.122.camel@x201>
References: <4DC6E569.1060808@kernel.org> <1305843308.3100.10.camel@x201>
	 <1306234696.7218.14.camel@i7.infradead.org> <1306258959.3100.79.camel@x201>
	 <4DDC0858.3090406@kernel.org> <1306267639.3100.102.camel@x201>
	 <4DDC26FE.6070207@kernel.org> <1306276736.3100.107.camel@x201>
	 <4DDC38FE.5010700@kernel.org> <4DDC9775.7000802@kernel.org>
	 <1306327429.3100.122.camel@x201>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306620697.2029.329.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 06:43 -0600, Alex Williamson wrote:
> 
> Ugh, that's going to make it pretty difficult to use a dynamic lookup
> approach.  Maybe we're stuck with caching the scope->pdev translation
> somewhere. 

Can't you handle it on BUS_NOTIFY_ADD_DEVICE notification, and store it
in pdev->dev.archdata? Might as well do the ATSR the same way, so it
matches.

Hm, why the hell do we have device_to_iommu(), which seems to duplicate
the dmar_find_matched_drhd_unit() function? Introduced by Weidong in
commit c7151a8d in 2008... Weidong?

I have a *vague* recollection that we cannot assume that there will be a
matching extant pci_dev for every call to device_to_iommu(), which is
why it takes domai^H^H^H^H^Hsegment/bus/devfn arguments as it does. And
that would be a reasonable excuse for adding it in the first place, I
suppose. I note your patch will break if that's true...

-- 
dwmw2

