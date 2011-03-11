Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab1CKOII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:08:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59620 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab1CKOIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 09:08:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 3/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
Date: Fri, 11 Mar 2011 15:07:59 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>, k.debski@samsung.com,
        kgene.kim@samsung.com, kyungmin.park@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        " =?euc-kr?q?=27=B4=EB=C0=CE=B1=E2=27?=" <inki.dae@samsung.com>,
        " =?euc-kr?q?=27=B0=AD=B9=CE=B1=D4=27?=" <mk7.kang@samsung.com>,
        "'KyongHo Cho'" <pullip.cho@samsung.com>, linux-kernel@vger.kernel.org
References: <1299229274-9753-4-git-send-email-m.szyprowski@samsung.com> <201103111250.51252.arnd@arndb.de> <000001cbdfe8$ce444b20$6acce160$%szyprowski@samsung.com>
In-Reply-To: <000001cbdfe8$ce444b20$6acce160$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="euc-kr"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111507.59825.arnd@arndb.de>
X-Provags-ID: V02:K0:20/IIe56rXkjSzD3KhQkDLVGroMhTy7sudZzHY1ZX4+
 22wGhchWQZjd0CKH6kl9lEG1xI+oJnc/9aQRB1vZ6Bxy1walTV
 QIQoTUyocYCjI6q3MZlmzqiBEdat+RIPLpkOeE+asgPZj+m0iA
 4LmJNEV1Mz1/xQ58hPH8SgUj7XHRBzKe6lOqbgJFhBRer4s0Tu
 1MMlM8sKWZ70DOKLEEpog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 March 2011, Marek Szyprowski wrote:
> > The iommu API is not really meant to be KVM specific, it's just that the
> > in-tree users are basically limited to KVM at the moment. Another user that
> > is coming up soon is the vmio device driver that can be used to transparently
> > pass devices to user space. The idea behind the IOMMU API is that you can
> > map arbitrary bus addresses to physical memory addresses, but it does not
> > deal with allocating the bus addresses or providing buffer management such
> > as cache flushes.
> 
> Yea, I've noticed this and this basically what we expect from iommu driver. 
> However the iommu.h API requires a separate call to map each single memory page.
> This is quite ineffective approach and imho the API need to be extended to allow
> mapping of the arbitrary set of pages.

We can always discuss extensions to the existing infrastructure, adding
an interface for mapping an array of page pointers in the iommu API
sounds like a good idea.

I also think that we should not really have separate iommu and dma-mapping
interfaces, but rather have a portable way to define an iommu so that it
can be used through the dma-mapping interfaces. I'm not asking you to
do that as a prerequisite to merging your driver, but it may be good to
keep in mind that the current situation is still lacking and that any
suggestion for improving this as part of your work to support the
samsung IOMMU is welcome.

Note that the ARM implementation of the dma-mapping.h interface currently
does not support IOMMUs, but that could be changed by wrapping it
using the include/asm-generic/dma-mapping-common.h infrastructure.

	Arnd
