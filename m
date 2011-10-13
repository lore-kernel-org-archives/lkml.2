Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1JMVDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 17:03:05 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:43353 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753809Ab1JMVDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 17:03:01 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: lgxJsWkVM1l0Gyba5JIz.tLWNoopbeN2dSFkKo30uAh.n.j
 DJfgnNWthDvmL4SA0O38BoJOMAP3n9WBaCe4umjY.9TTzmN05KcP8J2di0sc
 1dkD.Gr1vUinzU2jcsYO0aS8n6_11BEwV_QD666CK4mu_3alBywtMb7a9Lpq
 p07.6VMcUzaHzvlZjgx8Yr8U5dAmvsVTAXjANvzlNE6Uk_wz2iN56ECdPWL0
 mk9mIgXyHsCrtWan9trt75JF_oLBDchDYuii8eLBf.e0tRdPJFhTmezBjRrt
 XoJV06fLuQOW5uiTSsgAm4qdReI8hqYcnt2iVuoE78RrREwkXHU1Uh3Tog3S
 dpgfJR1pPOxsceMw1zmv83KlEO4BEfNXsr3wx1LRd6H3rDlQ-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 13 Oct 2011 16:02:58 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] Reduce vm_stat cacheline contention in
 __vm_enough_memory
In-Reply-To: <20111013135032.7c2c54cd.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1110131602020.26553@router.home>
References: <20111012160202.GA18666@sgi.com> <20111012120118.e948f40a.akpm@linux-foundation.org> <alpine.DEB.2.00.1110121452220.31218@router.home> <20111013152355.GB6966@sgi.com> <alpine.DEB.2.00.1110131052300.18473@router.home>
 <20111013135032.7c2c54cd.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Andrew Morton wrote:

> > If there are no updates occurring for a while (due to increased deltas
> > and/or vmstat updates) then the vm_stat cacheline should be able to stay
> > in shared mode in multiple processors and the performance should increase.
> >
>
> We could cacheline align vm_stat[].  But the thing is pretty small - we
> couild put each entry in its own cacheline.

Which in turn would increase the cache footprint of some key kernel
functions (because they need multiple vm_stat entries) and cause eviction
of other cachelines that then reduce overall system performance again.

