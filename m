Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab1HXS2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 14:28:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:9657 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab1HXS2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 14:28:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,276,1312182000"; 
   d="scan'208";a="10667570"
Subject: Re: [patch 3/8] iommu: move IOMMU specific code to intel-iommu.c
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 24 Aug 2011 11:31:40 -0700
In-Reply-To: <20110824092700.GF2079@amd.com>
References: <20110824000517.710353624@sbsiddha-desk.sc.intel.com>
	 <20110824001456.282401285@sbsiddha-desk.sc.intel.com>
	 <20110824092700.GF2079@amd.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1314210701.16133.13.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 02:27 -0700, Roedel, Joerg wrote:
> On Tue, Aug 23, 2011 at 08:05:20PM -0400, Suresh Siddha wrote:
> > +static void __init dmar_register_rmrr_unit(struct dmar_rmrr_unit *rmrr)
> > +int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header)
> > +int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
> > +int dmar_find_matched_atsr_unit(struct pci_dev *dev)
> > +int dmar_parse_rmrr_atsr_dev(void)
> 
> If these functions are not DMAR specific, how about replacing the dmar_
> prefix too while at it?

These parsing functions are APCI DMAR table specific and are used only
by intel-iommu routines. Because of this I didn't change their names but
just moved to intel-iommu.c to cleanup some of the ifdef's in the common
dmar.c code (specific to handling common ACPI DMAR tables etc) shared by
both DMA-remapping (iommu) and IRQ-remapping.

thanks,
suresh

