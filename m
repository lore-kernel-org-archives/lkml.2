Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966375Ab2JZUJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:09:52 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:11694 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966288Ab2JZUJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:09:51 -0400
Message-ID: <1351281735.19172.82.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 2/2] Improve container_notify_cb() to support
 container hot-remove.
From: Toshi Kani <toshi.kani@hp.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, yinghai@kernel.org, bhelgaas@google.com,
        lenb@kernel.org, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, mihailm@parallels.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 26 Oct 2012 14:02:15 -0600
In-Reply-To: <508A22EE.1000607@cn.fujitsu.com>
References: <1351058750-4275-1-git-send-email-tangchen@cn.fujitsu.com>
	   <1351058750-4275-3-git-send-email-tangchen@cn.fujitsu.com>
	  <1351098875.19172.21.camel@misato.fc.hp.com>
	  <5088967E.3060204@cn.fujitsu.com> <50889A14.9030607@huawei.com>
	 <1351185648.19172.51.camel@misato.fc.hp.com>
	 <508A22EE.1000607@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 13:43 +0800, Tang Chen wrote:
> Hi Toshi,
> 
> On 10/26/2012 01:20 AM, Toshi Kani wrote:
> ...
> >>>> Why do you need to call acpi_bus_trim(device,0) to stop the container
> >>>> device first?
> >>>
> >>> This issue was introduced by Lu Yinghai, I think he could give a better
> >>> answer than me. :)
> >>> Please refer to the following url:
> >>>
> >>> http://www.spinics.net/lists/linux-pci/msg17667.html
> >>>
> >>> However, this is not applied into the pci tree yet.
> >> We have worked out a patch set to clean up the logic for PCI/ACPI binding
> >> relationship. It updates PCI/ACPI binding relationship by registering bus
> >> notification onto pci_bus_type instead of hooking into the ACPI/glue.c.
> >
> > Thanks for the info and pointer.  Tang, I'd suggest you add such info to
> > the comment so that others know that this step is needed for removing
> > PCI bridges.  It helps us to know where to look at...
> 
> OK, I'll add it in the next version. :)
> 
> >
> >> To accommodate that patch set, the ACPI device destroy process has been
> >> split into two steps:
> >> 1) acpi_bus_trim(device,0) to unbind ACPI drivers
> >
> > Does this step also detach PCI drivers from PCI cards as well?
> 
> Yes, it calls device_release_driver() to release the device driver.
> 
>      device_release_driver()
>        |->__device_release_driver()
>             |->dev->driver = NULL;

I see.  Thanks for the info.
-Toshi


> 
> Thanks. :)
> 
> >
> > Thanks,
> > -Toshi
> >
> >
> 


