Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab0GNBvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 21:51:40 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:40235 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab0GNBvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 21:51:38 -0400
Date: Tue, 13 Jul 2010 20:50:14 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 1/2] vmscan: don't subtraction of unsined
In-Reply-To: <20100713182918.EA67.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1007132047001.14067@router.home>
References: <20100709090956.CD51.A69D9226@jp.fujitsu.com> <20100709152851.330bf2b2.akpm@linux-foundation.org> <20100713182918.EA67.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010, KOSAKI Motohiro wrote:

> Christoph, Can we hear your opinion about to add new branch in slab-free path?
> I think this is ok, because reclaim makes a lot of cache miss then branch
> mistaken is relatively minor penalty. thought?

Its on the slow path so I would think that should be okay. But is this
really necessary? Working with the per zone slab reclaim counters is not
enough? We are adding counter after counter that have similar purposes and
the handling gets more complex.

Maybe we can get rid of the code in the slabs instead by just relying on
the difference of the zone counters?

