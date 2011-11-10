Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955Ab1KJOvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:51:52 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:50353
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979Ab1KJOvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:51:50 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zz98dKzz1202hzz15d4Rz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LUG9A3-01-IN7-02
X-M-MSG: 
Date: Thu, 10 Nov 2011 15:51:10 +0100
From: Joerg Roedel <Joerg.Roedel@amd.com>
To: cody <mail.kai.huang@gmail.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, <iommu@lists.linux-foundation.org>,
        <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        KyongHo Cho <pullip.cho@samsung.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 2/7] iommu/core: split mapping to page sizes as
 supported by the hardware
Message-ID: <20111110145110.GD13213@amd.com>
References: <1318850846-16066-1-git-send-email-ohad@wizery.com>
 <1318850846-16066-3-git-send-email-ohad@wizery.com>
 <CANqQZNH1YRSgYRVxceicQ3szD=t7zeJjhJKEQ30PeKsxtj5V+A@mail.gmail.com>
 <CAK=WgbZbfCRJqA-wwHN=iLH6rYyoKjJCaL0zMfY93Tg6Jw2uvA@mail.gmail.com>
 <4EBBC090.4070109@gmail.com>
 <20111110130801.GC13213@amd.com>
 <4EBBE136.4030404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EBBE136.4030404@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 10:35:34PM +0800, cody wrote:
> Yes I totally agree page-size is not required for unmap operations
> and should not be added as parameter to map/unmap operations. I am
> not saying the unmap operation, but the IOTLB flush operation. My
> point is we also may also need to add similar logic in IOTLB flush
> code (such as in Intel IOMMU dirver) to grantee that when issuing
> IOTLB flush command for large page, we will still meet the hardware
> limitation of flushing large page. Seems for Intel IOMMU the only
> limitation is the mask value (indicating number of 4k-pages) cannot
> be smaller than the value to cover large page, and seems current
> Intel IOMMU driver code has covered this case well. I am not
> familiar with how AMD IOMMU issues IOTLB flush command, it should be
> able to handle this large page case too. So at this moment, this
> patch should not have any issues :)

The map-operation actually takes a size, as it should. The idea is to
change this function to a map_page interface which takes a page-size
parameter, but thats another story.
The IOTLB flushing is not exposed by the IOMMU-API anyway. To whatever
is necessary to do that, it is the business of the IOMMU driver. So in
the unmap-path the driver finds out the page-size to unmap and can
immediatly flush the IOTLB for that page.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

