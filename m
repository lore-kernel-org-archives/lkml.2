Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab1HBOPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 10:15:10 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:45969 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751867Ab1HBOPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 10:15:06 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zBRh5rwVM1ncbmLBRv6QxJg3pBYTSifWj0hD.wunBJ2OO_n
 5tcg5tBjMSamO6A17603O9.XWwk9iz9z2DObnV6Ja9RqMkXpMdyb2LmdOSs_
 uBeJgakhBvzblkIKpvQqTgmRMyDVc.7Xd2zP8Sh97Hoa4a.6_nLm91Q7LaO6
 8_HsFtItacd8hMvBYJYhxhtBuCHg3w0pRAHf1QldZ.fmy5xlnXtJYo2JeheD
 WMd5bZKwloesp5sJ6gQ8XHzymDPvuA5Btx3b7c2XbUnqzFYHXy70kF6fd1vL
 68HkFkAXdxgrCSv3Qb5nJbkL2ocK0Ij1h8OfqGIsHh2lZp9Ol
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 2 Aug 2011 09:15:03 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, hughd@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] Lockless SLUB slowpaths for v3.1-rc1
In-Reply-To: <alpine.DEB.2.00.1108012101310.6871@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1108020913180.18965@router.home>
References: <alpine.DEB.2.00.1107290145080.3279@tiger> <alpine.DEB.2.00.1107291002570.16178@router.home> <alpine.DEB.2.00.1107311136150.12538@chino.kir.corp.google.com> <alpine.DEB.2.00.1107311253560.12538@chino.kir.corp.google.com> <1312145146.24862.97.camel@jaguar>
 <alpine.DEB.2.00.1107311426001.944@chino.kir.corp.google.com> <CAOJsxLHB9jPNyU2qztbEHG4AZWjauCLkwUVYr--8PuBBg1=MCA@mail.gmail.com> <alpine.DEB.2.00.1108012101310.6871@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011, David Rientjes wrote:

> On Mon, 1 Aug 2011, Pekka Enberg wrote:
>
> > Btw, I haven't measured this recently but in my testing, SLAB has
> > pretty much always used more memory than SLUB. So 'throwing more
> > memory at the problem' is definitely a reasonable approach for SLUB.
> >
>
> Yes, slub _did_ use more memory than slab until the alignment of
> struct page.  That cost an additional 128MB on each of these 64GB
> machines, while the total slab usage on the client machine systemwide is
> ~75MB while running netperf TCP_RR with 160 threads.

I guess that calculation did not include metadata structures (alien caches
and the NR_CPU arrays in kmem_cache) etc? These are particularly costly on SLAB.

