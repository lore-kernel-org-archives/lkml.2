Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab1GLPL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 11:11:56 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:20426 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751054Ab1GLPLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 11:11:55 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ijWdrfoVM1n6eO3529jiz7LaI_QNH7anBmqbVWM7Qc0.00x
 C3yoaryDpISncAR8.EUGe6kovagHRmQjNZKXNzspDZapcqC_K1OUC8ieS.ns
 myQHupG9s14T4tiWLsNatQEQXr1iDtwK6jHAFLix_350bPRmlrhrrulutFmv
 7VEsaKQq3yYRAiYfUdeFeWa502ReIcqr_k7f0BM8LeGMGXtPRbmNsMcQKA1K
 gFY6Xrf9Rk7.aWQv.290TtfCaXki5oaLLB_pYw_4_EC6dSoPHyxGqFNz2lHF
 7E8nW5_TZrvTuTbrHoDLR15PDFkEm4uQ7eWhdVmugi7yhMErjn0IcUrWvKYh
 tQEEYux02wHjzD5iOGCw5Yy1I
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 12 Jul 2011 10:11:52 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next/mmotm] slub: partly fix freeze in __slab_free
In-Reply-To: <4E1BE5F9.10401@kernel.org>
Message-ID: <alpine.DEB.2.00.1107121010060.1672@router.home>
References: <alpine.LSU.2.00.1107111156310.13035@sister.anvils> <1310413167.2860.3.camel@edumazet-laptop> <4E1BE5F9.10401@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011, Pekka Enberg wrote:

> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 3d76a43..1351d28 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -62,7 +62,7 @@ struct page {
> >   		struct {			/* SLUB cmpxchg_double area */
> >   			void *freelist;
> >   			union {
> > -				unsigned long counters;
> > +				u64	counters;
> >   				struct {
> >   					unsigned inuse:16;
> >   					unsigned objects:15;
> >
>
> Christoph?


counters needs to overlay the bitfields as well as _count. That is problem
with the earlier fix.

Sorry I have had a power outage for the last two days (strange Chicago
weather) and my server is only up for a few minutes and will go down
periodically due to a UPS malfunction. On a generator. Sigh.


