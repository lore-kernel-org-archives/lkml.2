Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab2BHPOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 10:14:38 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:31552 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754110Ab2BHPOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 10:14:36 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5glHcxAVM1kBCm2FT9_Sx.GTmn7uO2cibsQVEIMlnqQ7exM
 f30XUSHaCCbwu4DuokRNKlTzoBea3Jd5LzyEo4DcAbJxeN5q2Xv12Gh_gv2V
 KDP29CcoMfMRdFa5PjLbGcTdlAo9mzbMEHwxsSQUrKwDBU4TQnkdtVm0MTxe
 OgwLy.ZTIhTbvpaTt0veG.YSQeCZkzFkgKMHiCJapt170RmkqZODemFUuqMp
 85l2TcBV70VYoez.TF3m3bFUFfyLtuEXYciHQ4oqg7sqeaHcknojGaT.h7_X
 rYa0JvuOWEIpDKn917ZubAvs3H5O1RGT.U61k64h83QCWnYl0yvIML8z.Yow
 QHxMn8daFwBmaLbTrgUnupMxW5.rvahd9rTBhIJdk5SNUefFUCHMs9NBndrE
 6eYa7aJA9ig7QyLMaVh_FQkQOCNp5Wi0b7X27
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 8 Feb 2012 09:14:32 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 02/15] mm: sl[au]b: Add knowledge of PFMEMALLOC reserve
 pages
In-Reply-To: <20120208144506.GI5938@suse.de>
Message-ID: <alpine.DEB.2.00.1202080907320.30248@router.home>
References: <1328568978-17553-1-git-send-email-mgorman@suse.de> <1328568978-17553-3-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1202071025050.30652@router.home> <20120208144506.GI5938@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Feb 2012, Mel Gorman wrote:

> o struct kmem_cache_cpu could be left alone even though it's a small saving

Its multiplied by the number of caches and by the number of
processors.

> o struct slab also be left alone
> o struct array_cache could be left alone although I would point out that
>   it would make no difference in size as touched is changed to a bool to
>   fit pfmemalloc in

Both of these are performance critical structures in slab.

> o It would still be necessary to do the object pointer tricks in slab.c

These trick are not done for slub. It seems that they are not necessary?

> remain. However, the downside of requiring a page flag is very high. In
> the event we increase the number of page flags - great, I'll use one but
> right now I do not think the use of page flag is justified.

On 64 bit I think there is not much of an issue with another page flag.

Also consider that the slab allocators do not make full use of the other
page flags. We could overload one of the existing flags. I removed
slubs use of them last year. PG_active could be overloaded I think.

