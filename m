Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab0GZQrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 12:47:31 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:42027 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752658Ab0GZQra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 12:47:30 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jul 2010 12:47:30 EDT
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 3O.vMUkVM1lA313gTdB0xOX9oRQfjc_DEntgtu_d.rQaErZ
 cJLAzUQsKfTlsWL6BVN7zNIxcw_ZjY1zZZGBl.5XkdWBP7SYDtajzABDWjCP
 mU4VghIwG_VB3YrDLJr6xsE15Yzm2ZI9eNY4KwdZgUWIEzSTTT_Fi3hnXXbW
 qSfq2RO90GnLgHLDT53Bu_VdQSSC4fGBcZrf2C7H_.ndcIPWQY.zJAidK9Xy
 ZEOKh657RDtIsuQw5sL2uAAxEVTVvFROvjQZhmDBAZn9lvd1h
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 26 Jul 2010 11:40:44 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mm <linux-mm@kvack.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
In-Reply-To: <1280159163-23386-1-git-send-email-minchan.kim@gmail.com>
Message-ID: <alpine.DEB.2.00.1007261136160.5438@router.home>
References: <1280159163-23386-1-git-send-email-minchan.kim@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010, Minchan Kim wrote:

> This patch registers address of mem_section to memmap itself's page struct's
> pg->private field. This means the page is used for memmap of the section.
> Otherwise, the page is used for other purpose and memmap has a hole.

What if page->private just happens to be the value of the page struct?
Even if that is not possible today, someday someone may add new
functionality to the kernel where page->pivage == page is used for some
reason.

Checking for PG_reserved wont work?

> +void mark_valid_memmap(unsigned long start, unsigned long end);
> +
> +#ifdef CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
> +static inline int memmap_valid(unsigned long pfn)
> +{
> +	struct page *page = pfn_to_page(pfn);
> +	struct page *__pg = virt_to_page(page);
> +	return page_private(__pg) == (unsigned long)__pg;

Hmmm.. hmmm....
