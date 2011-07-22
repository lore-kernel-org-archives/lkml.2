Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1GVGDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 02:03:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:49723 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab1GVGDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 02:03:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,245,1309762800"; 
   d="scan'208";a="30670042"
From: Andi Kleen <andi@firstfloor.org>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Nanosecond fs timestamp support: sad
References: <1311271641.14555.114.camel@calx>
Date: Thu, 21 Jul 2011 23:01:24 -0700
In-Reply-To: <1311271641.14555.114.camel@calx> (Matt Mackall's message of
	"Thu, 21 Jul 2011 13:07:21 -0500")
Message-ID: <m2pql2c0qz.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall <mpm@selenic.com> writes:


> This means I can touch a file something like 70k times per second and
> get only 300 distinct timestamps on my laptop. And only 100 distinct
> timestamps on a typical distro server kernel.

You should use the inode generation number if you really want
to see every update.

> Meanwhile, I can call gettimeofday 35M times per second and get ~1M
> distinct responses.

They key word here is "I".

> Given that we can do gettimeofday three orders of magnitude faster than
> we can do file transactions and it has four orders of magnitude better
> resolution, shouldn't we be using it for filesystem time when
> sb->s_time_gran is less than 1/HZ?

Some systems have a quite slow gettimeofday()
That was the primary motivation for using jiffies. 

Also adding more granuality makes it more expensive,
because there's additional work every time it changes.
Even jiffies already caused regressions.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
