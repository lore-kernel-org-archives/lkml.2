Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab1FOHil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 03:38:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54195 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab1FOHik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 03:38:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 08/10] mm: cma: Contiguous Memory Allocator added
Date: Wed, 15 Jun 2011 09:37:18 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-media@vger.kernel.org
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com> <201106142030.07549.arnd@arndb.de> <000501cc2b2b$789a54b0$69cefe10$%szyprowski@samsung.com>
In-Reply-To: <000501cc2b2b$789a54b0$69cefe10$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106150937.18524.arnd@arndb.de>
X-Provags-ID: V02:K0:seWrADaN+nWac43q5MaUu3druobV+Rm/7Nu9GkJZ+/k
 eTXUa37QM2bH74yZ6RWmmRTkKnDwwCA9oi3ExGPfjZHuH7XNvH
 RI3g+v2H80VtblH/pfvqoBhlxwkam/9XXsZNVhoYlg1uNtQ773
 bh7rUA2nXplZ5KElpI9cLh1PcE2hkzZ2RIal2Zr1J9na/B9vXG
 9w5KHAuLq576hoYJ/7Mbg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 June 2011 09:11:39 Marek Szyprowski wrote:
> I see your concerns, but I really wonder how to determine the properties
> of the global/default cma pool. You definitely don't want to give all
> available memory o CMA, because it will have negative impact on kernel
> operation (kernel really needs to allocate unmovable pages from time to
> time). 

Exactly. This is a hard problem, so I would prefer to see a solution for
coming up with reasonable defaults.

> The only solution I see now is to provide Kconfig entry to determine
> the size of the global CMA pool, but this still have some issues,
> especially for multi-board kernels (each board probably will have
> different amount of RAM and different memory-consuming devices
> available). It looks that each board startup code still might need to
> tweak the size of CMA pool. I can add a kernel command line option for
> it, but such solution also will not solve all the cases (afair there
> was a discussion about kernel command line parameters for memory 
> configuration and the conclusion was that it should be avoided).

The command line option can be a last resort if the heuristics fail,
but it's not much better than a fixed Kconfig setting.

How about a Kconfig option that defines the percentage of memory
to set aside for contiguous allocations?

	Arnd
