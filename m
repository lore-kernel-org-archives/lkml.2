Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab2DTIUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 04:20:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:41811 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab2DTIT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 04:19:59 -0400
Date: Fri, 20 Apr 2012 10:19:54 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Tom Herbert <therbert@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, Changli Gao <xiaosuo@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [PATCH] vmsplice: relax alignement requirements for
 SPLICE_F_GIFT
Message-ID: <20120420081953.GJ7505@kernel.dk>
References: <1333530531.18626.550.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333530531.18626.550.camel@edumazet-glaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04 2012, Eric Dumazet wrote:
> It seems there is no fundamental reason to limit vmsplice()
> SPLICE_F_GIFT to page aligned chunks.
> 
> All helpers are prepared to cope with offsets in page.
> 
> This limitation makes vmsplice() API very impractical in the zero-copy
> land.

Sorry for the slow reply on this one. It's been a long time since I
wrote that code... If I recall correctly, the reason it currently
requires alignment, is that a gifted page is no longer yours, by
definition. So the alignment check was to ensure that we gift full
pages. But if the caller screws that up, I guess it's the callers
problem and it's a shame to limit the API in this way.

I will apply it for 3.5.

-- 
Jens Axboe

