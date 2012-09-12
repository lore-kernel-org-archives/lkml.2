Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2ILWL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 18:11:27 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:50603 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab2ILWL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 18:11:26 -0400
Date: Thu, 13 Sep 2012 00:11:16 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Damian Hobson-Garcia <dhobsong@igel.co.jp>
Cc: horms@verge.net.au, magnus.damm@gmail.com, hjk@hansjkoch.de,
        linux-sh@vger.kernel.org, hdk@igel.co.jp, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH 0/2] Add UIO device supporting dynamic memory
 allocation
Message-ID: <20120912221116.GB5097@local>
References: <1347427785-9767-1-git-send-email-dhobsong@igel.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347427785-9767-1-git-send-email-dhobsong@igel.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 02:29:43PM +0900, Damian Hobson-Garcia wrote:
> Reposting: I realized that this series should have gone out to a broader list.

You forgot GregKH, I added him.

> My apologies to those who those who will recieve a duplicate post. 
> 
> Hello all,
> 
> I've been using this UIO driver for allocation/deallocation
> of memory regions through an IOMMU via the dma-mapping API, but
> it seems that it would be more generally useful for userspace drivers
> to access CMA memory regions. I don't know if it's useful to try to add
> this functionality into the core uio driver or not, so for now I've kept
> all dynamic memory handling in the specific device driver.
> 
> The number and size of the dynamically allocatable regions is defined
> statically in the device platform data, and the actually memory is
> allocated and deallocated when the device is opened/closed.
> 
> Details of the dynamically allocated regions are available from sysfs in
> exactly the same was as for static regions. The total number of
> dynamic and static regions combined cannot exceed MAX_UIO_MAPS.
> 
> Any comments, especially with regard to exposing the dma-mapping API to
> userspace in this way, would be greatly appreciated.
> 
> Damian Hobson-Garcia (2):
>   Add new uio device for dynamic memory allocation
>   ARM: shmobile: sh7372: Change VPU UIO to uio_dmem_genirq
> 
>  arch/arm/mach-shmobile/setup-sh7372.c         |   19 +-
>  drivers/uio/Kconfig                           |   16 ++
>  drivers/uio/Makefile                          |    1 +
>  drivers/uio/uio_dmem_genirq.c                 |  356 +++++++++++++++++++++++++
>  include/linux/platform_data/uio_dmem_genirq.h |   26 ++
>  5 files changed, 413 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/uio/uio_dmem_genirq.c
>  create mode 100644 include/linux/platform_data/uio_dmem_genirq.h

Please add a third patch with a few words for Documentation/DocBook/uio-howto.tmpl
since this driver could be useful for other people, too.

Otherwise, looks good to me.

Thanks,
Hans
