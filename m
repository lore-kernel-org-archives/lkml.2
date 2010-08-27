Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab0H0T3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 15:29:34 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:23081 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750781Ab0H0T3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 15:29:33 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: LbBDJRUVM1nr1FdTU4oE8KvBSCFhlFnyPw2lARfnwTyPwn2
 pYIhajPBRGtsxeB.GcNR_FG_2cGNJmimEN0gbQrLiQio9eOUPVRkyDo14p6b
 QNTI2iUhY7adVqLdv7pV1fjF7G_mUZb.rRinlSeW3jo5Dcs4qJB1iIWzhawl
 aRdyBT0hlQmFiEZSJw6sCoS84pmSnIzULCmJSQm9R_F5aQGvXbztwknbFe6A
 28PW_8wr4XzJz4DwfQ_ibHkKfcjXN
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 27 Aug 2010 14:29:28 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Hugh Dickins <hughd@google.com>
cc: Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix hang on anon_vma->root->lock
In-Reply-To: <AANLkTi=FeHnLu4_6M5N6yUL==4YyxVXXxsccsE2kNUbm@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1008271420400.18495@router.home>
References: <alpine.LSU.2.00.1008252305540.19107@sister.anvils> <20100826235052.GZ6803@random.random> <AANLkTimgKcP78CNakDf34NrVrd5apfXrtptNw+G6G5DK@mail.gmail.com> <20100827095546.GC6803@random.random> <AANLkTikvB1fN42A91ZdEHyEXnz2bGw9Q21dJcfa3PBP0@mail.gmail.com>
 <alpine.DEB.2.00.1008271159160.18495@router.home> <AANLkTi=FeHnLu4_6M5N6yUL==4YyxVXXxsccsE2kNUbm@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010, Hugh Dickins wrote:

> Eh?  My solution was a second page_mapped(page) test i.e. testing an atomic.

Argh. Right. Looked like a global to me. Did not see the earlier local
def.

If you still use a pointer then what does insure that the root
pointer was not changed after the ACCESS_ONCE? The free semantics
of an anon_vma?

Since there is no lock taken before the mapped check none of the
earlier reads from the anon vma structure nor the page mapped check
necessarily reflect a single state of the anon_vma.




