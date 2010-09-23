Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab0IWRNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:13:01 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:44158 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754503Ab0IWRNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:13:00 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: SmBDE_kVM1mGCfemp7zEscgjJu1hos61UtmqZaLVdxZi8C7
 S3F3OkzcUHc9QR0vrbg0CFO0MTb1a_dUdhdw.md7MmI.F8xNBa2bk7IFv.e9
 oE.CQsPp6G4YmQmvrTy09JsZXnSs4HWHRG1xs22vaarL1JF3lMuL5HwoY5U_
 exHVaMxKJLI6FWx35FUz_N8Ym8EQFBrtw80LLZHLQzQ608WaEMYuOCOrBqy1
 GFRnp15kzZOMg.Nh3KBEgWzAEut89PFzBkML0m2JOuQKlqOdsmuABXNKr.pk
 u0A--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 23 Sep 2010 12:12:55 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] hugetlb: move refcounting in hugepage allocation
 inside hugetlb_lock
In-Reply-To: <1283908781-13810-7-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.DEB.2.00.1009231209450.32567@router.home>
References: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1283908781-13810-7-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010, Naoya Horiguchi wrote:

> Currently alloc_huge_page() raises page refcount outside hugetlb_lock.
> but it causes race when dequeue_hwpoison_huge_page() runs concurrently
> with alloc_huge_page().
> To avoid it, this patch moves set_page_refcounted() in hugetlb_lock.

Reviewed-by: Christoph Lameter <cl@linux.com>

One wonders though how many other of these huge races are still there
though.

"Normal" page migration is based on LRU isolation and therefore does not
suffer from these problems on allocation since the page is not yet on the
LRU. Also the LRU isolation is a known issue due to memory reclaim doing
this.  This protection is going away of one goes directly to a page
without going through the LRU. That should create more races...

