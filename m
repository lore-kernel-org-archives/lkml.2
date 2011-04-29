Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364Ab1D2TIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:08:43 -0400
Received: from kroah.org ([198.145.64.141]:50227 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695Ab1D2S6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:54 2011
Message-Id: <20110429185653.951348075@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Williamson <alex.williamson@redhat.com>,
        Donald Dutile <ddutile@redhat.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [14/55] intel-iommu: Fix get_domain_for_dev() error path
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 2fe9723df8e45fd247782adea244a5e653c30bf4 upstream.

If we run out of domain_ids and fail iommu_attach_domain(), we
fall into domain_exit() without having setup enough of the
domain structure for this to do anything useful.  In fact, it
typically runs off into the weeds walking the bogus domain->devices
list.  Just free the domain.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Donald Dutile <ddutile@redhat.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1835,7 +1835,7 @@ static struct dmar_domain *get_domain_fo
 
 	ret = iommu_attach_domain(domain, iommu);
 	if (ret) {
-		domain_exit(domain);
+		free_domain_mem(domain);
 		goto error;
 	}
 


