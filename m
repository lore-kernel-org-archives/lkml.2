Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab0FIMM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:12:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62191 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228Ab0FIMMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:12:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Date: Wed, 9 Jun 2010 14:11:38 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: "Tom Lyon" <pugs@cisco.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, chrisw@sous-sol.org, joro@8bytes.org,
       hjk@linutronix.de, mst@redhat.com, avi@redhat.com, gregkh@suse.de,
       aafabbri@cisco.com, scofeldm@cisco.com
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com> <20100608144153.28d2abff.randy.dunlap@oracle.com>
In-Reply-To: <20100608144153.28d2abff.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006091411.38858.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1++8anvXWsR74ZQh6bGuActCeSsjEXBB5C3JgQ
 pBpSda08z11w2URRjuF6w6LLbNyUtBNFe6nbE/Q6R6AU4K+rLE
 sudVBEWF3rryF1WPH13wQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 June 2010, Randy Dunlap wrote:
>  Documentation/ioctl/ioctl-number.txt |    1 
>  Documentation/vfio.txt               |  177 +++++++
>  MAINTAINERS                          |    7 
>  drivers/Kconfig                      |    2 
>  drivers/Makefile                     |    1 
>  drivers/vfio/Kconfig                 |   18 
>  drivers/vfio/Makefile                |    6 
>  drivers/vfio/uiommu.c                |  126 +++++
>  drivers/vfio/vfio_dma.c              |  324 ++++++++++++
>  drivers/vfio/vfio_intrs.c            |  191 +++++++
>  drivers/vfio/vfio_main.c             |  624 +++++++++++++++++++++++++
>  drivers/vfio/vfio_pci_config.c       |  554 ++++++++++++++++++++++
>  drivers/vfio/vfio_rdwr.c             |  147 +++++
>  drivers/vfio/vfio_sysfs.c            |  153 ++++++
>  include/linux/uiommu.h               |   62 ++
>  include/linux/vfio.h                 |  200 ++++++++
>  16 files changed, 2593 insertions(+)

This seems to be missing a change to include/linux/Kbuild that
adds vfio.h to the exported files. Without the export, you cannot
use the definitions from user space programs unless they come with
their own copy of the header.

	Arnd
