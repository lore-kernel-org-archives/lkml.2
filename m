Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab1ELSQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:16:23 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:34193 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932370Ab1ELSQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:16:21 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: MbwqVQEVM1mceR9RBrgScgjUXiQIK7RlYVyyg1FctvvgoK0
 3M8nqvkBjVO3LwpF2tkQgwzL0ek1VkIx1.FUWOED0XfbTAaNmxELSpwWUJF1
 psfbrulBW15lkLLmX1nzoXiHu_LFOLC8cGghg8pPxkcLa4B89tlgHZpZM9sa
 JE4_aFBEXEGbWsCWlJshe5PScCChwaGJg9qBMecCw0G73qA5NtDw1JL9RjCQ
 mvEqWH1AxNyNkkQCp4H46hqmFQPyTvIM06jbWO0SAM5MqZmienX0C02.Go6G
 KZYfpuA7Z7IG9TPOgORj9AqDp5xwVSK2w2HmwnrGBcZfyfg6WSI_AAS6sMxt
 .tAv9e9r6vbjqBppjRb4xT_gh
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 12 May 2011 13:16:15 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Pekka Enberg <penberg@kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
In-Reply-To: <20110512180921.GP11579@random.random>
Message-ID: <alpine.DEB.2.00.1105121314530.29359@router.home>
References: <alpine.DEB.2.00.1105121024350.26013@router.home> <1305214993.2575.50.camel@mulgrave.site> <20110512154649.GB4559@redhat.com> <1305216023.2575.54.camel@mulgrave.site> <alpine.DEB.2.00.1105121121120.26013@router.home> <1305217843.2575.57.camel@mulgrave.site>
 <BANLkTi=MD+voG1i7uDyueV22_daGHPRdqw@mail.gmail.com> <BANLkTimDsJDht76Vm7auNqT2gncjpEKZQw@mail.gmail.com> <20110512175104.GM11579@random.random> <alpine.DEB.2.00.1105121302240.28493@router.home> <20110512180921.GP11579@random.random>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011, Andrea Arcangeli wrote:

> On Thu, May 12, 2011 at 01:03:05PM -0500, Christoph Lameter wrote:
> > On Thu, 12 May 2011, Andrea Arcangeli wrote:
> >
> > > even order 3 is causing troubles (which doesn't immediately make lumpy
> > > activated, it only activates when priority is < DEF_PRIORITY-2, so
> > > after 2 loops failing to reclaim nr_to_reclaim pages), imagine what
> >
> > That is a significant change for SLUB with the merge of the compaction
> > code.
>
> Even before compaction was posted, I had to shut off lumpy reclaim or
> it'd hang all the time with frequent order 9 allocations. Maybe lumpy
> was better before, maybe lumpy "improved" its reliability recently,

Well we are concerned about order 2 and 3 alloc here. Checking for <
PAGE_ORDER_COSTLY to avoid the order 9 lumpy reclaim looks okay.
