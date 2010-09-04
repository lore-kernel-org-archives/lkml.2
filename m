Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0IDAyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 20:54:15 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:42834 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753002Ab0IDAyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 20:54:07 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: STeVeHsVM1nDo4Vh_M5ytNjRWFURa5eOrgtccmUVV69symg
 ge9VzeyrDFXpxpLiLA6RHJpt.380K8_V_ymWnTNADYZKNkqSmuha79Qp9qpp
 x_HSKjbb5A.ZK5fNBei_MgoU7Ks_hpXy0yxpAhZzxg0Uu7mvUtySHutig9E8
 DVhT9sbImipiQ_FRsJnuxcCc.ALn35jwX8tGXdmiezUhZuo2Xg3_qkP3EeOn
 WDoCBZfcQ83QzkVPCzSRv6a0pqqJu
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 3 Sep 2010 19:54:01 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] mm: page allocator: Calculate a better estimate of
 NR_FREE_PAGES when memory is low and kswapd is awake
In-Reply-To: <20100903162821.48ec57cc.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1009031950100.18051@router.home>
References: <1283504926-2120-1-git-send-email-mel@csn.ul.ie> <1283504926-2120-3-git-send-email-mel@csn.ul.ie> <20100903155537.41f1a3a7.akpm@linux-foundation.org> <alpine.DEB.2.00.1009031811090.16264@router.home>
 <20100903162821.48ec57cc.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010, Andrew Morton wrote:

> > percpu counters must always be added up when their value is determined.
>
> Nope.  That's the difference between percpu_counter_read() and
> percpu_counter_sum().

Hmmm... Okay you can fold them therefore. That is analogous to what we do
in the _snapshot function now.
