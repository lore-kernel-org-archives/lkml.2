Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab2BUWhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 17:37:22 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46711 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab2BUWhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 17:37:21 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.217.42 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Tue, 21 Feb 2012 14:36:56 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/10] mm/memcg: introduce page_relock_lruvec
In-Reply-To: <20120221173859.f57d00f5.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.LSU.2.00.1202211426010.2012@eggly.anvils>
References: <alpine.LSU.2.00.1202201518560.23274@eggly.anvils> <alpine.LSU.2.00.1202201532170.23274@eggly.anvils> <20120221173859.f57d00f5.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Feb 2012, KAMEZAWA Hiroyuki wrote:
> 
> No perforamce impact by replacing spin_lock_irq()/spin_unlock_irq() to
> spin_lock_irqsave() and spin_unlock_irqrestore() ?

None that I noticed - but that is not at all a reassuring answer!

It worries me a little.  I think it would make more or less difference
on different architectures, and I forget where x86 stands there - one
of the more or the less affected?  Worth branches down inside
page_relock_lruvec()?

It's also unfortunate to be "losing" the information of where _irq
is needed and where _irqsave (but not much gets lost with git).

It's something that can be fixed - and I think Konstantin's version
already keeps the variants: I just didn't want to get confused by them,
while focussing on the locking details.

Hugh
