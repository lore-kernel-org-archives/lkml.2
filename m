Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab2IDTkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 15:40:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab2IDTkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 15:40:00 -0400
Date: Tue, 4 Sep 2012 15:39:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tj@kernel.org,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120904193949.GC2603@redhat.com>
References: <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120831014359.GB15218@moria.home.lan>
 <Pine.LNX.4.64.1209031638110.15620@file.rdu.redhat.com>
 <20120904034100.GA21602@moria.home.lan>
 <Pine.LNX.4.64.1209041509160.22689@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1209041509160.22689@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 03:26:19PM -0400, Mikulas Patocka wrote:

[..]
> BTW. can these new-style timerless plugs introduce deadlocks too? What 
> happens when some bios are indefinitely delayed because their requests are 
> held in a plug and a mempool runs out?

I think they will not deadlock because these on stack bios/requests are
flushed/dispatched when process schedules out. So if a submitter blocks
on a mempool, it will be scheduled out and requests on plug will be 
dispatched.

Thanks
Vivek
