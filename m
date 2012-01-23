Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab2AWOED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 09:04:03 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:58560 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab2AWOEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 09:04:02 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zz4015Lzz1202hzz15d4Rz2dhc1bhc31hc1ah668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LY98EI-01-5QC-02
X-M-MSG: 
Date: Mon, 23 Jan 2012 15:03:55 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: OMAP and MSM IOMMU driver misbehavior
Message-ID: <20120123140355.GA19255@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while reviewing another IOMMU driver again I came across a problem in
the IOMMU drivers for OMAP and MSM platforms. In both drivers the
'domain_destroy with devices attached' case isn't handled correctly.

OMAP driver seems not to track the devices attached to a domain at all.
So when a domain is destroyed it can happen that the hardware still
references old (and already freed) page-table pointers.

MSM tracks devices in a domain, but does not automatically remove the
devices from a domain that is about to be destroyed.

Please tell me when I mis-read the code, otherwise please fix this in
your drivers so that we can get consistent behavior for IOMMU-API
users :-)

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

