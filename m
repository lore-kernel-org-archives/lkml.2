Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab2HWF65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 01:58:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46216 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab2HWF6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 01:58:55 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-2b-5035c69df5e3
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Hiroshi Doyu'" <hdoyu@nvidia.com>, pullip.cho@samsung.com
Cc: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, arnd@arndb.de, linux@arm.linux.org.uk,
        chunsang.jeong@linaro.org, "'Krishna Reddy'" <vdumpa@nvidia.com>,
        konrad.wilk@oracle.com, subashrp@gmail.com, minchan@kernel.org
References: <1345630830-9586-1-git-send-email-hdoyu@nvidia.com>
 <1345630830-9586-3-git-send-email-hdoyu@nvidia.com>
 <CAHQjnOOF7Ca-Dz8K_zcS=gxQsJvKYaWA3tqUeK1RSd-wLYZ44w@mail.gmail.com>
 <20120822.163648.3800987367886904.hdoyu@nvidia.com>
In-reply-to: <20120822.163648.3800987367886904.hdoyu@nvidia.com>
Subject: RE: [RFC 2/4] ARM: dma-mapping: IOMMU allocates pages from pool with
 GFP_ATOMIC
Date: Thu, 23 Aug 2012 07:58:34 +0200
Organization: SPRC
Message-id: <012401cd80f4$59727020$0c575060$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2Aay6W1IqltmFFRWaC/1lscM4zfgAh+h5g
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jAd25x0wDDO5vVre4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZzYteshQ0cVQcnL2dsYFxFVsXIyeHhICJxKqFb6FsMYkL99YD
	2VwcQgKLGCW2zbwLlhASmMUksX6CBYjNJmAo0fW2CywuImArMWXmHlaQBmaBI0wS95v+QHV/
	YpRYeXsZI0gVp4CDRPPCO0AJDg5hgSiJ+1NDQcIsAqoSK6Y1sYKE+QWEJCbOUgAJ8wq4SGx8
	+58dwhaU+DH5HguIzSygJbF+53EmCFteYvOat8wgrRIC6hKP/upCnGMk0bl3FiNEiYjE3Ybn
	rBMYhWchmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZweD+T3sG4
	qsHiEKMAB6MSD29GrGmAEGtiWXFl7iFGCQ5mJRHe8HlAId6UxMqq1KL8+KLSnNTiQ4zSHCxK
	4rz8fYYBQgLpiSWp2ampBalFMFkmDk4pYKx8NjU5EsG0seU7i0r6ROFkjS98l553ly6tr3/8
	869L8fHLhcyfXgkyXxLk8ldIDU54OPv+XJavxyVWyD7P41Hr+Zp811n7R8UclmeTgl+qqcd7
	SjaxHgpdFJq2Pszhg7NDzLOi2deqMyP9I6LinY55btmuFDrvKOdZpgy7q+0fqvv4Lnp2KrEU
	ZyQaajEXFScCAMarrcNrAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wednesday, August 22, 2012 3:37 PM Hiroshi Doyu wrote:

> KyongHo Cho <pullip.cho@samsung.com> wrote @ Wed, 22 Aug 2012 14:47:00 +0200:
> 
> > vzalloc() call in __iommu_alloc_buffer() also causes BUG() in atomic context.
> 
> Right.
> 
> I've been thinking that kzalloc() may be enough here, since
> vzalloc() was introduced to avoid allocation failure for big chunk of
> memory, but I think that it's unlikely that the number of page array
> can be so big. So I propose to drop vzalloc() here, and just simply to
> use kzalloc only as below(*1).

We already had a discussion about this, so I don't think it makes much sense to
change it back to kzalloc. This vmalloc() call won't hurt anyone. It should not
be considered a problem for atomic allocations, because no sane driver will try
to allocate buffers larger than a dozen KiB with GFP_ATOMIC flag. I would call
such try a serious bug, which we should not care here.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



