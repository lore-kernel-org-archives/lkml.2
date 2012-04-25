Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab2DYFue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 01:50:34 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34860 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758149Ab2DYFud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 01:50:33 -0400
Date: Wed, 25 Apr 2012 13:50:11 +0800
From: Gavin Shan <shangw@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Ryan Wang <openspace.wang@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: 3.4-rc3 compile failed on IBM Power6
Message-ID: <20120425055011.GA978@shangw>
Reply-To: Gavin Shan <shangw@linux.vnet.ibm.com>
References: <CAPxxNQmfkJLPHq0BvzxOnLFO-e0FRmaF1VqLhP-jMqF-ziM2tA@mail.gmail.com>
 <20120425005432.GA14663@linux.vnet.ibm.com>
 <20120425015044.GA4637@shangw>
 <1335327042.21961.27.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335327042.21961.27.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12042419-7014-0000-0000-000000F9FCFC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> In order to make iommu.c irrelative to CONFIG_EEH, we might figure out
>> the PE number of the PCI device during PCI probe time. Here're some
>> rough thoughts about the rework.
>> 
>>         - Introduce additional field "int pe_num" to "struct dev_archdata".
>>           That would be traced like: (struct pci_dev)->(struct device dev)
>>           ->(struct dev_archdata archdata).
>>         - During the PCI probe time (maybe pci_fixup_early), we can figure
>>           out the PE number.
>> 
>> Then we can retrieve the PE number of PCI device from "int pe_num" and needn't
>> care CONFIG_EEH has been turned on or off. I'm not sure Ben has any comments
>> on the idea? 
>
>Just select EEH from pseries Kconfig, no point in keeping that a user visible option.
>

Thanks for the suggestion, Ben :-)

I've sent one trivial patch against it.

>Cheers,
>Ben.
>
>

Thanks,
Gavin

