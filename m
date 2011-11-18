Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab1KRP4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:56:20 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:30233 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757772Ab1KRP4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:56:19 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: bZTpZ6oVM1kRPfgeGYt9Ya0cUPL5mIyfIfhYEWL2d_zENbg
 tGBtBmNnrvCDqVIXtln_aoK1pepmDEyUsWSC_gCJiMbgEHREB89i7yggmNT4
 6Dtw71gIIv9w8N8HMVIxqCGvksLINfnrWBC.xDVKaV6KDbQFO35s1.989HJQ
 m6e6k844h4YOLl7ooBIdx9pBKP4Ci7iSoHKBKBMCf09WjBIjIFaTc8vb8jLl
 dnoGYxI5nrsEt4jRmgDocBhrYC9z9BAPhyoRgrEfLcu9HU4VcXG73THmAziG
 6qTyNHIYlTKrJUVTQ3npjGAEUUAFbq433TB.Ha2FvBoIHRvexvfcOU2pW7rb
 lejFsrFkFmdcDAu8qKzV9v3C0.V5AwfgbZohWhWO2WIKFgBFwo7dP6_yjkFf
 hce.jnvlPSSG1PNowR3i5Aw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 18 Nov 2011 09:56:15 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Shaohua Li <shaohua.li@intel.com>
cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, ak@linux.intel.com,
        Jens Axboe <axboe@kernel.dk>, lee.schermerhorn@hp.com
Subject: Re: [RFC]numa: improve I/O performance by optimizing numa interleave
 allocation
In-Reply-To: <1321600332.22361.309.camel@sli10-conroe>
Message-ID: <alpine.DEB.2.00.1111180954200.2242@router.home>
References: <1321600332.22361.309.camel@sli10-conroe>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011, Shaohua Li wrote:

> So can we make both interleave fairness and continuous allocation happy?

Maybe.

> Simplily we can adjust the round robin algorithm. We switch to another node
> after several (N) allocation happens. If N isn't too big, we can still get
> fair allocation. And we get N continuous pages. I use N=8 in below patch.
> I thought 8 isn't too big for modern NUMA machine. Applications which use
> interleave are unlikely run short time, so I thought fairness still works.

People are already complaining that the 4k interleaving is too coarse.
Bioses can often interleave on a cacheline level. A smaller size balances
the load better over multiple nodes. Large sizes can result in imbalances
since f.e. a whole array may end up on one node. Maybe make it tunable
by expanding the numa_policy structure to include a size parameter?


