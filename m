Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984Ab1JNN5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 09:57:21 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:33972 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756043Ab1JNN5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 09:57:19 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: z3yQSWUVM1lzpxljleN54erjPAkSp4hc3tIkJQcQf4o4Apw
 MTmi7v1vvcHuhpq.bohB6DQvxAvGJdreNGvgRByj_nwqC_5ZB6wDlmC6xOz7
 DxpPV9mjqTt3QKgT0h7XgjpHTVI8MvePGXLqvC_mgPC_Mm2H2yfhFhnQ1HPD
 3K9z2m2fpA19x7mCYax1eHsAKDnX84SpmNEUBUiS6tfVyekWCSr07GqmOIUI
 gyXK6W.ZFR7bDbtHS5pyo4wOaNv24hyyvYLgU7bp_JWhFBhs4zcAbkygCZUZ
 cz5jI37kYcQ4V3jxP8YkeWfsUvaBEQx1uGCAxQfkcBsSG_ip2LyyQDHA.uWv
 rhcmdQ7.wnE2wgd2A_AhjPkM.kVpwJ9O4jiZApwx12IspLrM-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 14 Oct 2011 08:57:16 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Dimitri Sivanich <sivanich@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] Reduce vm_stat cacheline contention in
 __vm_enough_memory
In-Reply-To: <20111014135055.GA28592@sgi.com>
Message-ID: <alpine.DEB.2.00.1110140856420.6411@router.home>
References: <20111012160202.GA18666@sgi.com> <20111012120118.e948f40a.akpm@linux-foundation.org> <alpine.DEB.2.00.1110121452220.31218@router.home> <20111013152355.GB6966@sgi.com> <alpine.DEB.2.00.1110131052300.18473@router.home> <20111013135032.7c2c54cd.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1110131602020.26553@router.home> <20111013142434.4d05cbdc.akpm@linux-foundation.org> <20111014122506.GB26737@sgi.com> <20111014135055.GA28592@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Dimitri Sivanich wrote:

> Testing on a smaller machine with 46 writer threads in parallel (my original
> test used 120).
>
> Looks as though cache-aligning and padding the end of the vm_stat array
> results in a ~150 MB/sec speedup.  This is a nice improvement for only 46
> writer threads, though it's not the full ~250 MB/sec speedup I get from
> setting OVERCOMMIT_NEVER.

Add to this the increase in the deltas for the ZVCs and change the stat
interval to 10 sec?

