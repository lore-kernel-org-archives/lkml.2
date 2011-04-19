Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab1DSQdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:33:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752156Ab1DSQd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:33:29 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimLOgY1opmAt+rxmYtLa-6adL98wg@mail.gmail.com>
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera> <_H4l51C1wXN.A.yDC.yGuqNB@chimera>
 <BANLkTimeaHwBiZoz=isCM=qtBxoxaBqDUw@mail.gmail.com> <BANLkTi=1jO73DXDTD50bVpU82qphVKmRCw@mail.gmail.com>
 <4DAC2429.5000105@fusionio.com> <BANLkTinCWWYqnksxevho9TN3u6ZC_Rjzwg@mail.gmail.com>
 <4DAC82E6.3020809@fusionio.com> <BANLkTimaekpwmK+z=ePE+XSP6GUteidwfw@mail.gmail.com>
 <4DAD5156.2050300@fusionio.com> <4DAD6EF2.5070405@fusionio.com> <BANLkTimLOgY1opmAt+rxmYtLa-6adL98wg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 19 Apr 2011 09:32:36 -0700
Message-ID: <BANLkTikzRE7sA8_NNgVUpOqR_zGtw+YUvQ@mail.gmail.com>
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>,
        David Dillow <dave@thedillows.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 9:13 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>
> The same test with an initiator running 2.6.39-rc4 +
> git://git.kernel.dk/linux-2.6-block.git for-linus + the above patch
> yields about 155.000 IOPS on my test setup, or the same performance as
> with 2.6.38.3. I'm running the above patch through an I/O stress test
> now.

Goodie. So not only does that patch get back the 11%, it removes the
crazy QUEUE_FLAG_REENTER flag that was broken to begin with. AND it
removes a number of complicated lines.

Halleluja.

                        Linus
