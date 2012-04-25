Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab2DYEK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 00:10:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:53552 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab2DYEKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 00:10:55 -0400
Message-ID: <1335327042.21961.27.camel@pasglop>
Subject: Re: 3.4-rc3 compile failed on IBM Power6
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Ryan Wang <openspace.wang@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Apr 2012 14:10:42 +1000
In-Reply-To: <20120425015044.GA4637@shangw>
References: <CAPxxNQmfkJLPHq0BvzxOnLFO-e0FRmaF1VqLhP-jMqF-ziM2tA@mail.gmail.com>
	 <20120425005432.GA14663@linux.vnet.ibm.com> <20120425015044.GA4637@shangw>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 09:50 +0800, Gavin Shan wrote:
> In order to make iommu.c irrelative to CONFIG_EEH, we might figure out
> the PE number of the PCI device during PCI probe time. Here're some
> rough thoughts about the rework.
> 
>         - Introduce additional field "int pe_num" to "struct dev_archdata".
>           That would be traced like: (struct pci_dev)->(struct device dev)
>           ->(struct dev_archdata archdata).
>         - During the PCI probe time (maybe pci_fixup_early), we can figure
>           out the PE number.
> 
> Then we can retrieve the PE number of PCI device from "int pe_num" and needn't
> care CONFIG_EEH has been turned on or off. I'm not sure Ben has any comments
> on the idea? 

Just select EEH from pseries Kconfig, no point in keeping that a user visible option.

Cheers,
Ben.


