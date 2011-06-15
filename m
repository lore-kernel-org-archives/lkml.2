Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab1FOLU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 07:20:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55018 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab1FOLUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 07:20:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michal Nazarewicz" <mina86@mina86.com>
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous Memory Allocator added
Date: Wed, 15 Jun 2011 13:20:42 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Zach Pfeffer" <zach.pfeffer@linaro.org>,
        "Daniel Stone" <daniels@collabora.com>,
        "Ankita Garg" <ankita@in.ibm.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Jesse Barker" <jesse.barker@linaro.org>, "Mel Gorman" <mel@csn.ul.ie>,
        linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, "Kyungmin Park" <kyungmin.park@samsung.com>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com> <201106142242.25157.arnd@arndb.de> <op.vw31uxxl3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <op.vw31uxxl3l0zgt@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106151320.42182.arnd@arndb.de>
X-Provags-ID: V02:K0:8Eqv+2QInl9Al3NRlUdQxLyYYL5ulr0DrwoAnnG/gO1
 4vjmZXQHw9sQ8ie010zxoj9r+6BnCQiOrrBAdLTIXgqk7c8mtq
 nx2hBllrtBogkBZeS02IGr/SJ376lFNaGg4XmcEz0utJxAHZGp
 k7u3nDckEsPzRIiCJ4NMF+DkNz2w78rxQJo82UTMg7W84dBioW
 QeWLvnY5fWz9R8fYEhz1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 June 2011, Michal Nazarewicz wrote:
> On Tue, 14 Jun 2011 22:42:24 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> > * We still need to solve the same problem in case of IOMMU mappings
> >   at some point, even if today's hardware doesn't have this combination.
> >   It would be good to use the same solution for both.
> 
> I don't think I follow.  What does IOMMU has to do with CMA?

The point is that on the higher level device drivers, we want to
hide the presence of CMA and/or IOMMU behind the dma mapping API,
but the device drivers do need to know about the bank properties.

If we want to solve the problem of allocating per-bank memory inside
of CMA, we also need to solve it inside of the IOMMU code, using
the same device driver interface.

	Arnd
