Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab2AJWdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:33:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605Ab2AJWdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:33:31 -0500
Date: Tue, 10 Jan 2012 14:33:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>, Dave Chinner <david@fromorbit.com>,
        nowhere <nowhere@hakkenden.ath.cx>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Kswapd in 3.2.0-rc5 is a CPU hog
Message-Id: <20120110143330.44cf1ccf.akpm@linux-foundation.org>
In-Reply-To: <20111227135658.08c8016a.kamezawa.hiroyu@jp.fujitsu.com>
References: <1324437036.4677.5.camel@hakkenden.homenet>
	<20111221095249.GA28474@tiehlicka.suse.cz>
	<20111221225512.GG23662@dastard>
	<1324630880.562.6.camel@rybalov.eng.ttk.net>
	<20111223102027.GB12731@dastard>
	<1324638242.562.15.camel@rybalov.eng.ttk.net>
	<20111223204503.GC12731@dastard>
	<20111227111543.5e486eb7.kamezawa.hiroyu@jp.fujitsu.com>
	<20111227035730.GA22840@barrios-laptop.redhat.com>
	<20111227135658.08c8016a.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Dec 2011 13:56:58 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Hmm, if I understand correctly,
> 
>  - dd's speed down is caused by kswapd's cpu consumption.
>  - kswapd's cpu consumption is enlarged by shrink_slab() (by perf)
>  - kswapd can't stop because NORMAL zone is small.
>  - memory reclaim speed is enough because dd can't get enough cpu.
> 
> I wonder reducing to call shrink_slab() may be a help but I'm not sure
> where lock conention comes from...

Nikolay, it sounds as if this problem has only recently started
happening?  Was 3.1 OK?

If so, we should work out what we did post-3.1 to cause this.
