Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab1KWK4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:56:24 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:16770
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654Ab1KWK4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:56:22 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz98dKzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LV411Q-01-2KM-02
X-M-MSG: 
Date: Wed, 23 Nov 2011 11:56:12 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Chris Wright <chrisw@sous-sol.org>
CC: Joerg Roedel <joro@8bytes.org>, <linux-pci@vger.kernel.org>,
        <dwmw2@infradead.org>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iommu: Include MSI susceptibility to DMA in creating
 iommu groups
Message-ID: <20111123105612.GD11876@amd.com>
References: <20111117170800.3125.84150.stgit@bling.home>
 <20111118104651.GJ5627@amd.com>
 <1321628190.26410.63.camel@bling.home>
 <20111118152710.GA5098@amd.com>
 <1321633956.26410.126.camel@bling.home>
 <20111120120043.GB20535@8bytes.org>
 <20111121233505.GG3344@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111121233505.GG3344@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 03:35:05PM -0800, Chris Wright wrote:

> What is the value of a group w/out complete isolation?

There is still isolation for DMA. This may be sufficient for non-KVM
use-cases like a device driver partially implemented in userspace. There
is no no guest then that can attack the host with wrong interrupts.

> Is there a practical problem w/ conflating the subtleties above?

Same argument as above. It ties the the iommu_group interface to the KVM
use case. Another more pratical impact of this patch is that a reboot is
required to re-enable iommu-groups. When the check happens in VFIO it is
a simple module-reload.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

