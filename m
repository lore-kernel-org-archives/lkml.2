Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab1LAUy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 15:54:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1LAUy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 15:54:58 -0500
Date: Thu, 1 Dec 2011 12:54:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Xi Wang <xi.wang@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: incorrect overflow check in shrink_slab()
Message-Id: <20111201125457.fdf79489.akpm@linux-foundation.org>
In-Reply-To: <20111201183202.2e5bd872.kamezawa.hiroyu@jp.fujitsu.com>
References: <0D9D9F79-204D-4460-8CE7-A583C5C38A1E@gmail.com>
	<20111201183202.2e5bd872.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011 18:32:02 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > total_scan is unsigned long, so the overflow check (total_scan < 0)
> > didn't work.
> > 
> > Signed-off-by: Xi Wang <xi.wang@gmail.com>
> 
> Nice catch but.... the 'total_scan" shouldn't be long ?
> Rather than type casting ?

Konstantin Khlebnikov's "vmscan: fix initial shrinker size handling"
does change it to `long'.  That patch is in -mm and linux-next and is
queued for 3.3.  It was queued for 3.2 but didn't make it due to some
me/Dave Chinner confusion.


