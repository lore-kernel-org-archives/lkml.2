Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab2DXTUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:20:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:50475 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab2DXTUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:20:44 -0400
Message-ID: <1335295211.28150.221.camel@twins>
Subject: Re: [PATCH 2/3] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Tue, 24 Apr 2012 21:20:11 +0200
In-Reply-To: <1335289787-11089-3-git-send-email-john.stultz@linaro.org>
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org>
	 <1335289787-11089-3-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 10:49 -0700, John Stultz wrote:
> +/*
> + * Purges volatile ranges when under memory pressure
> + */
> +static int volatile_shrink(struct shrinker *ignored, struct shrink_control *sc)
> +{ 

Hmm, I would have expected regular page reclaim to know about this
instead of using a shrinker interface. Is this done specifically to
avoid growing small holes in all ranges and instead dump entire ranges
thereby keeping other ranges usable?
