Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1ECPbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:31:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58761 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab1ECPbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:31:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Date: Tue, 3 May 2011 17:31:24 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linaro-mm-sig@lists.linaro.org, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <201104212129.17013.arnd@arndb.de> <201104271243.16868.arnd@arndb.de> <201105031705.39957.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105031705.39957.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031731.24626.arnd@arndb.de>
X-Provags-ID: V02:K0:6ix7qm81MOLha/62xSaSZ8zAayqx4vOqww9hd+DCYPX
 jH1RVj2JVZQs7bu0gksXKSKALFQD2n6zD5bkPThSUFB/4Xq9U2
 0bOT800OS/TbUT4RV7ETDPLs1rjrL/0ZX7+aNWCd1DPEKXNZcm
 u5eNjoHEGqpDuDwx2q7/cdeyfidj9CPTd6CWoLN0KAmyapuyTM
 03CwJ2yFPFn+I/ylGwxGQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 May 2011, Laurent Pinchart wrote:
> I wish it was that simple.
> 
> The OMAP4 ISS (Imaging Subsystem) has no IOMMU, but it can use the OMAP4 DMM 
> (Dynamic Memory Manager) which acts as a memory remapper. Basically (if my 
> understanding is correct), the ISS is configured to read/write from/to 
> physical addresses. If those physical addresses are in the DMM address range, 
> the DMM translates the accesses to physical accesses, acting as an IOMMU.
> 
> The ISS can thus write to physically contiguous memory directly, or to 
> scattered physical pages through the DMM. Whether an IOMMU (or, to be correct 
> in this case, the IOMMU-like DMM) needs to handle the DMA is a per-buffer 
> decision, not a per-device decision.

This doesn't sound too unusual for IOMMU implementations. A lot of time
you can access e.g. low memory using a direct mapping but you need the
IOMMU code for highmem. I've also seen a machine where a linear mapping
exists for all the memory in strict ordering, while you can use relaxed
DMA ordering when you go through the IOMMU address range. If we manage
to come up with a common dma-mapping API implementation for all IOMMUs,
it certainly needs to handle that case as well.

	Arnd
