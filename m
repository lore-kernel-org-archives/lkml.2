Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab0FHVmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 17:42:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43039 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0FHVmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 17:42:32 -0400
Date: Tue, 8 Jun 2010 14:41:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Tom Lyon" <pugs@cisco.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, mst@redhat.com, avi@redhat.com,
       gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Message-Id: <20100608144153.28d2abff.randy.dunlap@oracle.com>
In-Reply-To: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4C0EB930.003D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jun 2010 14:21:52 -0700 Tom Lyon wrote:

one missing piece (again):

 Documentation/ioctl/ioctl-number.txt |    1 
 Documentation/vfio.txt               |  177 +++++++
 MAINTAINERS                          |    7 
 drivers/Kconfig                      |    2 
 drivers/Makefile                     |    1 
 drivers/vfio/Kconfig                 |   18 
 drivers/vfio/Makefile                |    6 
 drivers/vfio/uiommu.c                |  126 +++++
 drivers/vfio/vfio_dma.c              |  324 ++++++++++++
 drivers/vfio/vfio_intrs.c            |  191 +++++++
 drivers/vfio/vfio_main.c             |  624 +++++++++++++++++++++++++
 drivers/vfio/vfio_pci_config.c       |  554 ++++++++++++++++++++++
 drivers/vfio/vfio_rdwr.c             |  147 +++++
 drivers/vfio/vfio_sysfs.c            |  153 ++++++
 include/linux/uiommu.h               |   62 ++
 include/linux/vfio.h                 |  200 ++++++++
 16 files changed, 2593 insertions(+)


> diff -uprN linux-2.6.34/drivers/vfio/Kconfig vfio-linux-2.6.34/drivers/vfio/Kconfig
> --- linux-2.6.34/drivers/vfio/Kconfig	1969-12-31 16:00:00.000000000 -0800
> +++ vfio-linux-2.6.34/drivers/vfio/Kconfig	2010-06-07 15:28:14.000000000 -0700
> @@ -0,0 +1,18 @@
> +menuconfig VFIO
> +	tristate "Non-Priv User Space PCI drivers"

	          Non-privileged
(again)

> +	depends on UIOMMU && PCI && IOMMU_API
> +	help
> +	  Driver to allow advanced user space drivers for PCI, PCI-X,
> +	  and PCIe devices.  Requires IOMMU to allow non-privilged

	                                             non-privileged
(again)  :(

> +	  processes to directly control the PCI devices.
> +
> +	  If you don't know what to do here, say N.
> +
> +menuconfig UIOMMU
> +	tristate "User level manipulation of IOMMU"
> +	help
> +	  Device driver to allow user level programs to
> +	  manipulate IOMMU domains

	                   domains.

> +
> +	  If you don't know what to do here, say N.
> +


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
