Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab3AIVsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:48:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab3AIVsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:48:18 -0500
Date: Wed, 9 Jan 2013 13:48:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zlatko Calusic <zlatko.calusic@iskon.hr>
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: wait for congestion to clear on all zones
Message-Id: <20130109134816.db51a820.akpm@linux-foundation.org>
In-Reply-To: <50EDE41C.7090107@iskon.hr>
References: <50EDE41C.7090107@iskon.hr>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jan 2013 22:41:48 +0100
Zlatko Calusic <zlatko.calusic@iskon.hr> wrote:

> Currently we take a short nap (HZ/10) and wait for congestion to clear
> before taking another pass with lower priority in balance_pgdat(). But
> we do that only for the highest zone that we encounter is unbalanced
> and congested.
> 
> This patch changes that to wait on all congested zones in a single
> pass in the hope that it will save us some scanning that way. Also we
> take a nap as soon as congested zone is encountered and sc.priority <
> DEF_PRIORITY - 2 (aka kswapd in trouble).
> 
> ...
>
> The patch is against the mm tree. Make sure that
> mm-avoid-calling-pgdat_balanced-needlessly.patch is applied first (not
> yet in the mmotm tree). Tested on half a dozen systems with different
> workloads for the last few days, working really well!

But what are the user-observable effcets of this change?  Less kernel
CPU consumption, presumably?  Did you quantify it?

