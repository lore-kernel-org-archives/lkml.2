Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590Ab1FWPbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:31:46 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:31384
	"EHLO CH1EHSOBE016.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754110Ab1FWPbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:31:44 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LN91SP-02-H5Y-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, David Brown <davidb@codeaurora.org>,
        <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/2] Introduce iommu_commit() function
Date: Thu, 23 Jun 2011 17:31:21 +0200
Message-ID: <1308843083-10442-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch-set introduces a new function into the iommu-api:

	iommu_commit(domain);

It needs to be called whenever a some code changed a domain (either by
attaching/detaching devices or by mapping/unmapping pages in
the domain).

IOMMU drivers can implement the new commit-callback to coalesce any
cache flushing on the CPU and in the IOMMU hardware which is necessary
after changes have been made to a domain.

David, I think especially VT-d can benefit from such a callback. I will
implement support for it in the AMD IOMMU driver and post a patch-set
soon.

Any comments, thoughts?

Thanks,

	Joerg



