Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab1ELSAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:00:18 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:26461 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758354Ab1ELSAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:00:16 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: DPHbD6wVM1kN3ol.QbUQBbqdsUbQ4wHLRYM_92pJD805mmK
 lw07pbTo2Kd3ri5rwJDpGp9j5TNBGKiYCyYtbyndmLCmNttPjnoH17PufLiz
 LhrDGU0rTfDN4R6O6wKBuQrF1hfnmabZKQVAJH2BBmn_b8k2LhQR6aqu2XZR
 ikZmcKyjJfQU7d2Kv00880cNLMpn24wkeAVzFVtXboBqhignlgWh1XZWAO_9
 JpOe5RU5W3pK86K.4HTyiU.79Uw6i8gNPtyLddWlTwrtCQrojXWz0uv9tvqY
 BzYFJKlsdk36wgW7e.C9t2y.BTxvbg8WYMbZLNTPDoq9MHl5J
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 12 May 2011 13:00:10 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrea Arcangeli <aarcange@redhat.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
In-Reply-To: <20110512174641.GL11579@random.random>
Message-ID: <alpine.DEB.2.00.1105121255060.28493@router.home>
References: <1305127773-10570-4-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1105120942050.24560@router.home> <1305213359.2575.46.camel@mulgrave.site> <alpine.DEB.2.00.1105121024350.26013@router.home> <1305214993.2575.50.camel@mulgrave.site>
 <20110512154649.GB4559@redhat.com> <1305216023.2575.54.camel@mulgrave.site> <alpine.DEB.2.00.1105121121120.26013@router.home> <1305217843.2575.57.camel@mulgrave.site> <alpine.DEB.2.00.1105121144320.27324@router.home> <20110512174641.GL11579@random.random>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011, Andrea Arcangeli wrote:

> order 1 should work better, because it's less likely we end up here
> (which leaves RECLAIM_MODE_LUMPYRECLAIM on and then see what happens
> at the top of page_check_references())
>
>    else if (sc->order && priority < DEF_PRIORITY - 2)

Why is this DEF_PRIORITY - 2? Shouldnt it be DEF_PRIORITY? An accomodation
for SLAB order 1 allocs?

May I assume that the case of order 2 and 3 allocs in that case was not
very well tested after the changes to introduce compaction since people
were focusing on RHEL testing?

