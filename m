Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab0DPM2C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 08:28:02 -0400
Received: from cantor.suse.de ([195.135.220.2]:52465 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab0DPM2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 08:28:00 -0400
Subject: CFQ read performance regression
From: Miklos Szeredi <mszeredi@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Suresh Jayaraman <sjayaraman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 14:27:58 +0200
Message-ID: <1271420878.24780.145.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I'm chasing a performance bottleneck identified by tiobench that seems
to be caused by CFQ.  On a SLES10-SP3 kernel (2.6.16, with some patches
moving cfq closer to 2.6.17) tiobench with 8 threads gets about 260MB/s
sequential read throughput.  On a recent kernels (including vanilla
2.6.34-rc) it makes about 145MB/s, a regression of 45%.  The queue and
readahead parameters are the same.

This goes back some time, 2.6.27 already seems to have a bad
performance.

Changing the scheduler to noop will increase the throughput back into
the 260MB/s range.  So this is not a driver issue.

Also increasing quantum *and* readahead will increase the throughput,
but not by as much.  Both noop and these tweaks decrease the write
throughput somewhat however...

Apparently on recent kernels the number of dispatched requests stays
mostly at or below 4 and the dispatched sector count at or below 2000,
which is not enough to fill the bandwidth on this setup.

On 2.6.16 the number of dispatched requests hovers around 22 and the
sector count around 16000.

I uploaded blktraces for the read part of the tiobench runs for both
2.6.16 and 2.6.32:

 http://www.kernel.org/pub/linux/kernel/people/mszeredi/blktrace/

Do you have any idea about the cause of this regression?

Thanks,
Miklos

