Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab1DSDwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 23:52:31 -0400
Received: from amavis-outgoing1.knology.net ([24.214.64.230]:36280 "EHLO
	amavis-outgoing1.knology.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282Ab1DSDwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 23:52:30 -0400
X-Greylist: delayed 1213 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Apr 2011 23:52:30 EDT
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
From: David Dillow <dave@thedillows.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>
In-Reply-To: <BANLkTinCWWYqnksxevho9TN3u6ZC_Rjzwg@mail.gmail.com>
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera>
	 <_H4l51C1wXN.A.yDC.yGuqNB@chimera>
	 <BANLkTimeaHwBiZoz=isCM=qtBxoxaBqDUw@mail.gmail.com>
	 <BANLkTi=1jO73DXDTD50bVpU82qphVKmRCw@mail.gmail.com>
	 <4DAC2429.5000105@fusionio.com>
	 <BANLkTinCWWYqnksxevho9TN3u6ZC_Rjzwg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 23:32:14 -0400
Message-ID: <1303183934.2585.12.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 20:21 +0200, Bart Van Assche wrote:
> On Mon, Apr 18, 2011 at 1:44 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
> > Bart, can you try and pull:
> >
> > git://git.kernel.dk/linux-2.6-block.git for-linus
> >
> > into Linus' tree and see if that works? This has, among other things,
> > Neils fixes for MD.
> 
> md seems to work stable with the resulting tree, but it looks there is
> a performance regression in the block layer not related to the md
> issue. If I run a small block IOPS test on a block device created by
> ib_srp (NOOP scheduler) I see about 11% less IOPS than with 2.6.38.3
> (155.000 IOPS with 2.6.38.3 and 140.000 IOPS with 2.6.39-rc3+).

The mapping code for ib_srp changed in 2.6.39-rc1, but it showed
improved IOPS for a similar setup in my testing so I'd be surprised if
it is the culprit. Still, it wouldn't hurt to check. Do you have time to
try the new ib_srp code with 2.6.38.3 to eliminate it from the equation?

Thanks,
Dave

