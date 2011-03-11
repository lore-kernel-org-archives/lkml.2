Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab1CKQA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:00:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58049 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1CKQA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:00:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 3/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
Date: Fri, 11 Mar 2011 17:00:17 +0100
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
References: <1299229274-9753-4-git-send-email-m.szyprowski@samsung.com> <201103111615.01829.arnd@arndb.de> <000201cbe002$768d9de0$63a8d9a0$%szyprowski@samsung.com>
In-Reply-To: <000201cbe002$768d9de0$63a8d9a0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="euc-kr"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111700.17373.arnd@arndb.de>
X-Provags-ID: V02:K0:qZAAHjP+wNfU+JESn/worXLAnj0QkJj0M63eHkpDzp+
 o7ioLrwatZQztTZ5PHNOgNbkkxgYJqXtZvIjUwtDnwXDC//sUp
 w9MkKPzc/DGDlKdiFgP27tlqMQ9BHLqpGOO9J79kgRiIqX8B4k
 3hI3m3bdm32/Sb+Dg58S2rcwkP2dmUercKggicYNc/zqyQXHhN
 qtDAhLNjvjSHneID6RoAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 March 2011, Marek Szyprowski wrote:
> > > > does not support IOMMUs, but that could be changed by wrapping it
> > > > using the include/asm-generic/dma-mapping-common.h infrastructure.
> > >
> > > ARM dma-mapping framework also requires some additional research for better DMA
> > > support (there are still issues with multiple mappings to be resolved).
> > 
> > You mean mapping the same memory into multiple devices, or a different problem?
> 
> Mapping the same memory area multiple times with different cache settings is not
> legal on ARMv7+ systems. Currently the problems might caused by the low-memory
> kernel linear mapping and second mapping created for example by dma_alloc_coherent()
> function.

Yes, I know this problem, but I don't think the case you describe is a serious
limitation (there are more interesting cases, though): dma_map_single() etc
will create additional *bus* addresses for a physical address, not additional
virtual addresses.

dma_alloc_coherent should allocate memory that is not also mapped cached,
which is what I thought we do correctly.

	Arnd
