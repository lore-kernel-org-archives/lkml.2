Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab1DMSjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:39:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671Ab1DMSjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:39:14 -0400
Date: Wed, 13 Apr 2011 19:21:27 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: raz ben yehuda <raziebe@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.38 sbrk regression
Message-ID: <20110413172127.GB5734@random.random>
References: <1302692638.15225.14.camel@raz.scalemp.com>
 <20110413125146.GR29444@random.random>
 <1302703579.17536.1.camel@raz.scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302703579.17536.1.camel@raz.scalemp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 05:06:19PM +0300, raz ben yehuda wrote:
> ok, managed to build 38-rc3 ( keep forgetting make mrproper ).
> problem is still there:

Oops I thought it was typo on your prev email so I didn't answer
assuming you would test 39-rc like I suggested in my prev email, I
really meant 2.6.39-rc3.

The fix I refer to is d527caf22e48480b102c7c6ee5b9ba12170148f7 and
it's included in >= 2.6.39-rc1. 38-rc3 has THP but not this
changeset. We tried to push it for 38 final but it was a bit late so
it got merged immediately in 39-rc1 to stay on the safe side (it's
only a performance issue and the other longstanding irq/sched latency
issues in compaction that got fixed in 39-rc1 where actually more
relevant than the compaction-kswapd removal).
