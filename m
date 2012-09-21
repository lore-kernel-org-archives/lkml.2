Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab2IUQwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:52:24 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:39316 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456Ab2IUQwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:52:22 -0400
Date: Fri, 21 Sep 2012 12:41:13 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Query of zram/zsmalloc promotion
Message-ID: <20120921164112.GD4780@phenom.dumpdata.com>
References: <20120912023914.GA31715@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912023914.GA31715@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 11:39:14AM +0900, Minchan Kim wrote:
> Hi all,
> 
> I would like to promote zram/zsmalloc from staging tree.
> I already tried it https://lkml.org/lkml/2012/8/8/37 but I didn't get
> any response from you guys.
> 
> I think zram/zsmalloc's code qulity is good and they
> are used for many embedded vendors for a long time.
> So it's proper time to promote them.
> 
> The zram should put on under driver/block/. I think it's not
> arguable but the issue is which directory we should keep *zsmalloc*.
> 
> Now Nitin want to keep it with zram so it would be in driver/blocks/zram/
> But I don't like it because zsmalloc touches several fields of struct page
> freely(and AFAIRC, Andrew had a same concern with me) so I want to put
> it under mm/.

I like the idea of keeping it in /lib or /mm. Actually 'lib' sounds more
appropriate since it is dealing with storing a bunch of pages in a nice
layout for great density purposes.
> 
> In addtion, now zcache use it, too so it's rather awkward if we put it
> under dirver/blocks/zram/.
> 
> So questions.
> 
> To Andrew:
> Is it okay to put it under mm/ ? Or /lib?
> 
> To Jens:
> Is it okay to put zram under drvier/block/ If you are okay, I will start sending
> patchset after I sort out zsmalloc's location issue.

I would think it would be OK.
> 
> -- 
> Kind regards,
> Minchan Kim
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
