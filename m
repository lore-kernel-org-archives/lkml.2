Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab2CUPvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:51:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab2CUPvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:51:07 -0400
Date: Wed, 21 Mar 2012 11:50:56 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
cc: device-mapper development <dm-devel@redhat.com>,
        "Alasdair G. Kergon" <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] Fix I/O counts in vmstat
In-Reply-To: <4F69A798.4000200@ce.jp.nec.com>
Message-ID: <Pine.LNX.4.64.1203211148220.23047@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1203202336370.15617@file.rdu.redhat.com>
 <4F69A798.4000200@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 Mar 2012, Jun'ichi Nomura wrote:

> Hi Mikulas,
> 
> > The decision whether bio is counted or not is made by the code that
> > submits the bio. This leads to some problems:
> 
> How about convering dm targets to use generic_make_request?

The problem would be raid1 resynchronization. There are no incoming bios 
when resynchronizing, but the administrator still needs to see the 
resynchronization workload in vmstat. The code path that submits bios for 
resynchronization is the same as the path that handles write requests.

Also dm-over-loop would still result in double-counting, even if we use 
generic_make_request in dm.

Mikulas

> Since submit_bio counts vm events, it seems natural for
> caller to decide which function to use.
> Device driver does not know whether the requested I/O is
> for vm-to-device or device-to-device.
> We could still use iostat to measure throughput of individual
> block devices. 
> 
> Thanks,
> -- 
> Jun'ichi Nomura, NEC Corporation
> 
