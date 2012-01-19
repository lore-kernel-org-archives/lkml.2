Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab2ASHgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 02:36:51 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27295 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2ASHgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 02:36:46 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Thu, 19 Jan 2012 08:36:38 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [Linaro-mm-sig] [PATCH 04/11] mm: page_alloc: introduce
 alloc_contig_range()
In-reply-to: <CA+K6fF6A1kPUW-2Mw5+W_QaTuLfU0_m0aMYRLOg98mFKwZOhtQ@mail.gmail.com>
To: "'sandeep patil'" <psandeep.s@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jonathan Corbet'" <corbet@lwn.net>, "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Dave Hansen'" <dave@linux.vnet.ibm.com>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>
Message-id: <002901ccd67d$1465e560$3d31b020$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: AczVYrIxz1VdCh4pRPqLMRzjCh73NgAcTb2g
References: <1325162352-24709-1-git-send-email-m.szyprowski@samsung.com>
 <1325162352-24709-5-git-send-email-m.szyprowski@samsung.com>
 <CA+K6fF6A1kPUW-2Mw5+W_QaTuLfU0_m0aMYRLOg98mFKwZOhtQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, January 17, 2012 10:54 PM sandeep patil wrote:

> I am running a CMA test where I keep allocating from a CMA region as long
> as the allocation fails due to lack of space.
> 
> However, I am seeing failures much before I expect them to happen.
> When the allocation fails, I see a warning coming from __alloc_contig_range(),
> because test_pages_isolated() returned "true".
> 
> The new retry code does try a new range and eventually succeeds.

(snipped)

> From the log it looks like the warning showed up because page->private
> is set to MIGRATE_CMA instead of MIGRATE_ISOLATED.

> I've also had a test case where it failed because (page_count() != 0)

This means that the page is temporarily used by someone else (like for example
io subsystem or a driver).

> Have you or anyone else seen this during the CMA testing?

Yes, we observed such issues and we are also working on fixing them. However 
we gave higher priority to get the basic CMA patches merged to mainline. Once
this happen the above issues can be fixed incrementally.

> Also, could this be because we are finding a page within (start, end)
> that actually belongs
> to a higher order Buddy block ?

No, such pages should be correctly handled.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


