Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1AUQLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:11:08 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:35444 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751816Ab1AUQLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:11:06 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: XZu60iIVM1mcQAe6W8_kFUNjpTy4SM35xqC37NKU.4gwDuO
 b5UuHq5NrCAZaQ2GtLiogM9Nx0fuuHl566ZDuGJWzkBkE2fpWwFRu0zX0bOg
 YYL5phVoAPlkVeDfiWEqnnnZEv.fsDwbEqujJ_7f4RJden05zB2WXioHLb46
 YEGvhj7b_I8YJY9W53jy6f136vz8Z3WNk3RkIRiuObE6F0kh7Lj4PkGBFXOy
 vQNm1kgUG2SXiKML7HfdgEHALmGLLXGFUN.dN
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 21 Jan 2011 10:11:03 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/3] When migrate_pages returns 0, all pages must have
 been released
In-Reply-To: <20110120212841.GB9506@random.random>
Message-ID: <alpine.DEB.2.00.1101211005150.14313@router.home>
References: <f60d811fd1abcb68d40ac19af35881d700a97cd2.1295539829.git.minchan.kim@gmail.com> <alpine.DEB.2.00.1101201130100.10695@router.home> <20110120182444.GA9506@random.random> <alpine.DEB.2.00.1101201233001.20633@router.home>
 <20110120212841.GB9506@random.random>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011, Andrea Arcangeli wrote:

> Which following putback_lru_page()?  You mean
> putback_lru_page(newpage)? That is for the newly allocated page
> (allocated at the very top, so always needed), it's not relevant to
> the page_count(page) = 1. The page_count 1 is hold by the caller, so
> it's leaking memory right now (for everything but compaction).

Ahh yes we removed the putback_lru_pages call from migrate_pages()
and broke the existing release logic. The caller has to call
putback_release_pages() as per commit
cf608ac19c95804dc2df43b1f4f9e068aa9034ab

If that is still the case then we still have the double free.

Could we please document the calling conventions exactly in the source?
Right now it says that the caller should call putback_lru_pages().


