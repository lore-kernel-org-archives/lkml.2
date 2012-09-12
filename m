Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626Ab2ILChP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 22:37:15 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53650 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442Ab2ILChM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 22:37:12 -0400
X-AuditID: 9c930197-b7b93ae0000028a7-c2-504ff556675b
Date: Wed, 12 Sep 2012 11:39:14 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Query of zram/zsmalloc promotion
Message-ID: <20120912023914.GA31715@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I would like to promote zram/zsmalloc from staging tree.
I already tried it https://lkml.org/lkml/2012/8/8/37 but I didn't get
any response from you guys.

I think zram/zsmalloc's code qulity is good and they
are used for many embedded vendors for a long time.
So it's proper time to promote them.

The zram should put on under driver/block/. I think it's not
arguable but the issue is which directory we should keep *zsmalloc*.

Now Nitin want to keep it with zram so it would be in driver/blocks/zram/
But I don't like it because zsmalloc touches several fields of struct page
freely(and AFAIRC, Andrew had a same concern with me) so I want to put
it under mm/.

In addtion, now zcache use it, too so it's rather awkward if we put it
under dirver/blocks/zram/.

So questions.

To Andrew:
Is it okay to put it under mm/ ? Or /lib?

To Jens:
Is it okay to put zram under drvier/block/ If you are okay, I will start sending
patchset after I sort out zsmalloc's location issue.

-- 
Kind regards,
Minchan Kim
