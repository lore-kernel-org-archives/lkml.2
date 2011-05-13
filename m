Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab1EMQhC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:37:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:18167 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab1EMQhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:37:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,365,1301900400"; 
   d="scan'208";a="1876256"
From: Andi Kleen <andi@firstfloor.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: x86@kernel.org, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: Possible sandybridge livelock issue
References: <1305303156.2611.51.camel@mulgrave.site>
Date: Fri, 13 May 2011 09:36:21 -0700
In-Reply-To: <1305303156.2611.51.camel@mulgrave.site> (James Bottomley's
	message of "Fri, 13 May 2011 11:12:36 -0500")
Message-ID: <m262pezhfe.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:
>
> When the hang occurred, kswapd basically pegged one core in 100% system
> time.  This looks like there's something specific to sandybridge that
> causes this type of bad interaction.  I was wondering if it could be
> something to to with a scheduling problem in turbo mode?  Once kswapd
> goes flat out, the core its on will kick into turbo mode, which causes
> it to get preferentially scheduled there, leading to the live lock.

Sounds unlikely to me.

Turbo mode does not affect the scheduler and the cores are (reasonably) 
independent.


> The only evidence I have to support this theory is that when I reproduce
> the problem with PREEMPT, the core pegs at 100% system time and stays
> there even if I turn off the load.  However, if I can execute work that
> causes kswapd to be kicked off the core it's running on, it will calm
> back down and go to sleep.

Turbo mode just makes the CPU faster, but it should not change 
the scheduler decisions.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
