Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab1DRSVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 14:21:23 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62611 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab1DRSVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 14:21:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=p0RSPUFc1locMXTIkEQe9yDhnwGcwfng/yMmeyX5klvXgdTjtbdL65rZgPcAfHLQxP
         SMk42PlG84zAQoEfnmTktl/koD9vU/7XuW8nVJYcqR6ASbVrxiQM+U/JRqeOp2mdmcUa
         0KVBqL1KIoKlF+CDYKubiBvOqH3oSw2YKVzyI=
MIME-Version: 1.0
In-Reply-To: <4DAC2429.5000105@fusionio.com>
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera> <_H4l51C1wXN.A.yDC.yGuqNB@chimera>
 <BANLkTimeaHwBiZoz=isCM=qtBxoxaBqDUw@mail.gmail.com> <BANLkTi=1jO73DXDTD50bVpU82qphVKmRCw@mail.gmail.com>
 <4DAC2429.5000105@fusionio.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 18 Apr 2011 20:21:00 +0200
X-Google-Sender-Auth: U2kK0jcBS7PQ041Ckmico78XZfY
Message-ID: <BANLkTinCWWYqnksxevho9TN3u6ZC_Rjzwg@mail.gmail.com>
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 1:44 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
> Bart, can you try and pull:
>
> git://git.kernel.dk/linux-2.6-block.git for-linus
>
> into Linus' tree and see if that works? This has, among other things,
> Neils fixes for MD.

md seems to work stable with the resulting tree, but it looks there is
a performance regression in the block layer not related to the md
issue. If I run a small block IOPS test on a block device created by
ib_srp (NOOP scheduler) I see about 11% less IOPS than with 2.6.38.3
(155.000 IOPS with 2.6.38.3 and 140.000 IOPS with 2.6.39-rc3+).

Bart.
