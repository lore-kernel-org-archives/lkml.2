Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab2FHNRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:17:09 -0400
Received: from david.siemens.de ([192.35.17.14]:32700 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab2FHNRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:17:05 -0400
Message-ID: <4FD1FB49.3020905@siemens.com>
Date: Fri, 08 Jun 2012 15:16:57 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
CC: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
References: <1339156616.3870.9.camel@blech> <20120608130351.GB1964@redhat.com>
In-Reply-To: <20120608130351.GB1964@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-08 15:03, Michael S. Tsirkin wrote:
>> +    /* set master */
>> +	pci_set_master(pdev);
>> +
>> +    /* set DMA mask */
>> +	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
> 
> uio currently only supports devices which do not
> do DMA.
> 
> DMA from uio controlled devices is a no no unless
> it's behind an IOMMU which can protect us from
> random memory corruptions this could cause.
> 
> In the later case it's OK but we need some code
> to check this and program the IOMMU appropriately.

AKA: VFIO. :)

Dominic, maybe you want to have a look at Alex's work:
https://github.com/awilliam/linux-vfio

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
