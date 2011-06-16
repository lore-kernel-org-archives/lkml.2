Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab1FPHDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:03:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56250 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab1FPHDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:03:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Philip Balister <philip@balister.org>
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous 
 =?iso-8859-1?q?Memory=09Allocator?= added
Date: Thu, 16 Jun 2011 09:03:12 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        "'Daniel Walker'" <dwalker@codeaurora.org>, linux-mm@kvack.org,
        "'Mel Gorman'" <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        linaro-mm-sig@lists.linaro.org,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-media@vger.kernel.org,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com> <201106150937.18524.arnd@arndb.de> <4DF952CC.4010301@balister.org>
In-Reply-To: <4DF952CC.4010301@balister.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106160903.13135.arnd@arndb.de>
X-Provags-ID: V02:K0:7gKdQbh5jZ7ku1PDxn/BBeJvtNsegzx/753OCARsIeh
 i0n63ohAsQIglPH3yoUsKNcxKrnFpVage1B2WiQM+UrBu8lhFR
 sjEDHHJSzTM6+VSc4Wt0hD/3Lo8M3Pmu0ZriWY4I1SeosbRscg
 HpekYFsHiBbidmsLi6QfKiCGI0b7r8kxOsj53jWzHxWpHEiRKL
 aX6KkFRdxjcj8GQ5to7Jw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 June 2011 02:48:12 Philip Balister wrote:
> On 06/15/2011 12:37 AM, Arnd Bergmann wrote:
> > On Wednesday 15 June 2011 09:11:39 Marek Szyprowski wrote:
> >> I see your concerns, but I really wonder how to determine the properties
> >> of the global/default cma pool. You definitely don't want to give all
> >> available memory o CMA, because it will have negative impact on kernel
> >> operation (kernel really needs to allocate unmovable pages from time to
> >> time).
> >
> > Exactly. This is a hard problem, so I would prefer to see a solution for
> > coming up with reasonable defaults.
> 
> Is this a situation where passing the information from device tree might 
> help? I know this does not help short term, but I am trying to 
> understand the sorts of problems device tree can help solve.

The device tree is a good place to describe any hardware properties such
as 'this device will need 32 MB of contiguous allocations on the memory
bank described in that other device node'.

It is however not a good place to describe user settings such as 'I want
to give this device a 200 MB pool for large allocations so I can run
application X efficiently', because that would require knowledge in the
boot loader about local policy, which it should generally not care about.

	Arnd
