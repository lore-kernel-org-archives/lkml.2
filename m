Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0DVH7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 03:59:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39336 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab0DVH7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 03:59:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hucslt6yG/gSCrjiIe+bIjhwhyqQrOg9+PqOjoIAiyQBZai7vQpOT545p+BK82VkGL
         Q4P4DYBOyohaML/mV8mr7DXEF6CQ8u7gqVcb6jOsVH497+MIWScXVTj0X+IofgwDKblt
         Don52ZHmypWPWINTy8gcNryWLorwEN/eCMVBE=
MIME-Version: 1.0
In-Reply-To: <1271865911.24780.292.camel@tucsk.pomaz.szeredi.hu>
References: <1271420878.24780.145.camel@tucsk.pomaz.szeredi.hu>
	 <h2m4e5e476b1004170546z8997cd90h98ecfb9cc5aad8cf@mail.gmail.com>
	 <1271677562.24780.184.camel@tucsk.pomaz.szeredi.hu>
	 <j2t4e5e476b1004201350xbd08a002l3329fbdd4fb1b8db@mail.gmail.com>
	 <1271856324.24780.285.camel@tucsk.pomaz.szeredi.hu>
	 <1271865911.24780.292.camel@tucsk.pomaz.szeredi.hu>
Date: Thu, 22 Apr 2010 09:59:14 +0200
Message-ID: <p2t4e5e476b1004220059u2263832atf36ee33ae83463fa@mail.gmail.com>
Subject: Re: CFQ read performance regression
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Suresh Jayaraman <sjayaraman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,
On Wed, Apr 21, 2010 at 6:05 PM, Miklos Szeredi <mszeredi@suse.cz> wrote:
> Jens, Corrado,
>
> Here's a graph showing the number of issued but not yet completed
> requests versus time for CFQ and NOOP schedulers running the tiobench
> benchmark with 8 threads:
>
> http://www.kernel.org/pub/linux/kernel/people/mszeredi/blktrace/queue-depth.jpg
>
> It shows pretty clearly the performance problem is because CFQ is not
> issuing enough request to fill the bandwidth.
>
> Is this the correct behavior of CFQ or is this a bug?
 This is the expected behavior from CFQ, even if it is not optimal,
since we aren't able to identify multi-splindle disks yet. Can you
post the result of "grep -r . ." in your /sys/block/*/queue directory,
to see if we can find some parameter that can help identifying your
hardware as a multi-spindle disk.
>
> This is on a vanilla 2.6.34-rc4 kernel with two tunables modified:
>
> read_ahead_kb=512
> low_latency=0 (for CFQ)
You should get much better throughput by setting
/sys/block/_your_disk_/queue/iosched/slice_idle to 0, or
/sys/block/_your_disk_/queue/rotational to 0.

Thanks,
Corrado
>
> Thanks,
> Miklos
>
>
>
