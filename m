Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab1DQRE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 13:04:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261Ab1DQREW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 13:04:22 -0400
MIME-Version: 1.0
In-Reply-To: <_H4l51C1wXN.A.yDC.yGuqNB@chimera>
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera> <_H4l51C1wXN.A.yDC.yGuqNB@chimera>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 17 Apr 2011 10:03:27 -0700
Message-ID: <BANLkTimeaHwBiZoz=isCM=qtBxoxaBqDUw@mail.gmail.com>
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Bart Van Assche <bart.vanassche@gmail.com>, Neil Brown <neilb@suse.de>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this machine running a RAID5 setup or something like that?

There is a known interaction with the new block layer plugging code
and MD. The "hung task" report in that bugzilla looks very much like
that issue. And you do have "root=/dev/md0", so clearly there's some
md thing going on.

And bisecting might not work all that well for it, because I suspect
it ends up being very much a matter of IO patterns how it triggers.

Neil supposedly has a patch for it, but I haven't seen it yet. Neil, Jens?

                                   Linus

On Sun, Apr 17, 2011 at 5:57 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.38.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=32982
> Subject         : Kernel locks up a few minutes after boot
> Submitter       : Bart Van Assche <bart.vanassche@gmail.com>
> Date            : 2011-04-10 19:55 (8 days old)
>
>
>
