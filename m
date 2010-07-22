Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab0GVEyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 00:54:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34691 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab0GVEyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 00:54:49 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6050"; a="48092253"
Date: Wed, 21 Jul 2010 21:54:35 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Xiaolin Zhang <xiaolin.zhang@intel.com>,
        Hiremath Vaibhav <hvaibhav@ti.com>,
        Robert Fekete <robert.fekete@stericsson.com>,
        Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
Message-ID: <20100722045435.GD22559@codeaurora.org>
References: <cover.1279639238.git.m.nazarewicz@samsung.com>
 <d6d104950c1391eaf3614d56615617cee5722fb4.1279639238.git.m.nazarewicz@samsung.com>
 <adceebd371e8a66a2c153f429b38068eca99e99f.1279639238.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adceebd371e8a66a2c153f429b38068eca99e99f.1279639238.git.m.nazarewicz@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 05:51:25PM +0200, Michal Nazarewicz wrote:
> The Contiguous Memory Allocator framework is a set of APIs for
> allocating physically contiguous chunks of memory.
> 
> Various chips require contiguous blocks of memory to operate.  Those
> chips include devices such as cameras, hardware video decoders and
> encoders, etc.
> 
> The code is highly modular and customisable to suit the needs of
> various users.  Set of regions reserved for CMA can be configured on
> run-time and it is easy to add custom allocator algorithms if one
> has such need.
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reviewed-by: Pawel Osciak <p.osciak@samsung.com>
> ---
>  Documentation/cma.txt               |  435 +++++++++++++++++++
>  Documentation/kernel-parameters.txt |    7 +
>  include/linux/cma-int.h             |  183 ++++++++
>  include/linux/cma.h                 |   92 ++++
>  mm/Kconfig                          |   41 ++
>  mm/Makefile                         |    3 +
>  mm/cma-allocators.h                 |   42 ++
>  mm/cma-best-fit.c                   |  360 ++++++++++++++++
>  mm/cma.c                            |  778 +++++++++++++++++++++++++++++++++++
>  9 files changed, 1941 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/cma.txt
>  create mode 100644 include/linux/cma-int.h
>  create mode 100644 include/linux/cma.h
>  create mode 100644 mm/cma-allocators.h
>  create mode 100644 mm/cma-best-fit.c
>  create mode 100644 mm/cma.c
> 
> diff --git a/Documentation/cma.txt b/Documentation/cma.txt
> new file mode 100644
> index 0000000..7edc20a
> --- /dev/null
> +++ b/Documentation/cma.txt
> @@ -0,0 +1,435 @@
> +                                                             -*- org -*-
> +
> +* Contiguous Memory Allocator
> +
> +   The Contiguous Memory Allocator (CMA) is a framework, which allows
> +   setting up a machine-specific configuration for physically-contiguous
> +   memory management. Memory for devices is then allocated according
> +   to that configuration.
> +
> +   The main role of the framework is not to allocate memory, but to
> +   parse and manage memory configurations, as well as to act as an
> +   in-between between device drivers and pluggable allocators. It is
> +   thus not tied to any memory allocation method or strategy.
> +

This topic seems very hot lately. I recently sent out a few RFCs that
implement something called a Virtual Contiguous Memory Manager that
does what this patch does, and works for IOMMU and works for CPU
mappings. It also does multihomed memory targeting (use physical set 1
memory for A allocations and use physical memory set 2 for B
allocations). Check out:

mm: iommu: An API to unify IOMMU, CPU and device memory management
mm: iommu: A physical allocator for the VCMM
mm: iommu: The Virtual Contiguous Memory Manager

It unifies IOMMU and physical mappings by creating a one-to-one
software IOMMU for all devices that map memory physically.

It looks like you've got some good ideas though. Perhaps we can
leverage each other's work.
