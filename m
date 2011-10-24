Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab1JXErs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 00:47:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:36540 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab1JXErr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 00:47:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="66342899"
From: Andi Kleen <andi@firstfloor.org>
To: Eial Czerwacki <eial@scalemp.com>
Cc: linux-kernel@vger.kernel.org,
        "Shai Fultheim \(Shai\@ScaleMP.com\)" <Shai@scalemp.com>
Subject: Re: [PATCH] Move mostly read variables to __read_mostly section.
References: <4EA45BB8.20505@scalemp.com>
Date: Sun, 23 Oct 2011 21:47:45 -0700
In-Reply-To: <4EA45BB8.20505@scalemp.com> (Eial Czerwacki's message of "Sun,
	23 Oct 2011 20:23:52 +0200")
Message-ID: <m2sjmj572m.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eial Czerwacki <eial@scalemp.com> writes:
>   * Once the number of bh's in the machine exceeds this level, we start
> --- a/kernel/time/timekeeping.c	2010-05-12 14:59:32.000000000 -0700
> +++ b/kernel/time/timekeeping.c	2010-05-24 11:56:32.000000000 -0700
> @@ -154,7 +154,7 @@ __cacheline_aligned_in_smp DEFINE_SEQLOC
>   * used instead.
>   */
>  static struct timespec xtime __attribute__ ((aligned (16)));
> -static struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
> +static struct timespec wall_to_monotonic __attribute__ ((aligned
>   (16))) __read_mostly;

That means that a common time fetch/update call will usually have to fetch two
cachelines now instead of one, because it needs xtime and
wall_to_monotonic. Usually those end up nearby.

On the other hand it's rare to fetch wall_to_monotonic without xtime.

So if anything all those variables should be grouped together in a
single cacheline, but definitely not split like you do.

The other changes in your patch are fine for me.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
