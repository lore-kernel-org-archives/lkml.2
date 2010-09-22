Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab0IVVFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 17:05:52 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:28495 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750819Ab0IVVFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 17:05:51 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ChXndxsVM1llZqKUtVPM58YYU1kJ94wHvaeI0ruzL4IR9C5
 6oh18s1v6IT5hrq06IoUO0X18uCVWClI9mf3HurXIO5CFz0K8kapjEfzVfpt
 sl.AzsSkycXsjiN4gDUODSUh3iPze3bOvIFrrBCot8jq_hNiVBK49ENH1Nnb
 qGqlRbXJDo9jkqC8p6lr5rYYR.QpwsOns6gcnEljZ0DDJN0S25j5wWFLWIge
 4
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 22 Sep 2010 16:05:47 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        tony.luck@intel.com
Subject: Re: [PATCH 02/10] hugetlb: add allocate function for hugepage
 migration
In-Reply-To: <1283908781-13810-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.DEB.2.00.1009221558000.32661@router.home>
References: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1283908781-13810-3-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010, Naoya Horiguchi wrote:

> We can't use existing hugepage allocation functions to allocate hugepage
> for page migration, because page migration can happen asynchronously with
> the running processes and page migration users should call the allocation
> function with physical addresses (not virtual addresses) as arguments.

Ummm... Some arches like IA64 need huge pages fixed at certain virtual
addresses in which only huge pages exist. A vma is needed in order to be
able to assign proper virtual address to the page.

How does that work with transparent huge pages anyways?

This looks like its going to break IA64 hugepage support for good. Maybe
thats okay given the reduced significance of IA64? Certainly would
simplify the code.

