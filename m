Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0IWQVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 12:21:30 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:33160 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754460Ab0IWQVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 12:21:30 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: SsyCJdYVM1kqFoQ9zp1wM1E65741OqJaMr7.Sx3Nnv559Bq
 GxCawf2JEo5VC1s8V7Gct5WzeqBPDFvuqC_bYRBaq7SQAMZNx2qKvCp0sfDo
 PK36LyHCpIgf7uVz9abCfCnkPh3mAW1tCAUe5IsoHEnper34LLU0RgrIN8Ff
 HSYiPbTEgtwoz39cFqDNLPeDF097XfT25d3SuJwIVPcP_0Q_GH89xNRm5xsl
 QCtYEl42NLjyI8.M_QkQ_9H27oiVyeVrR8A--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 23 Sep 2010 11:21:25 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] hugetlb: redefine hugepage copy functions
In-Reply-To: <1283908781-13810-4-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.DEB.2.00.1009231114030.32567@router.home>
References: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1283908781-13810-4-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010, Naoya Horiguchi wrote:

> This patch modifies hugepage copy functions to have only destination
> and source hugepages as arguments for later use.
> The old ones are renamed from copy_{gigantic,huge}_page() to
> copy_user_{gigantic,huge}_page().
> This naming convention is consistent with that between copy_highpage()
> and copy_user_highpage().

Looking at copy_user_highpage(): The vma parameter does not seem to be
used anywhere anymore? The vaddr is used on arches that have virtual
caching.

Maybe removing the vma parameter would allow to simplify the hugetlb
code?

Reviewed-by: Christoph Lameter <cl@linux.com>


