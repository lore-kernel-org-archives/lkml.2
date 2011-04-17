Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1DQSiH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 14:38:07 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39524 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1DQSiB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 14:38:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=nxWF5ow+/SF4vw5BrVaZPN2bs1CXc6DhmgXdF3zI87qmrsUvKLZrt67dRpo+5oFPJ6
         z/uYiv24ZDvMcgcZj0m4HpcmQH58HucGA44r8inGYD1fPPqUCM1hN5SBvls1Bfjrwnpl
         afgQPOFJtbUgv0bdFWxGIDiQvRV2SvxIvzMew=
MIME-Version: 1.0
In-Reply-To: <BANLkTimeaHwBiZoz=isCM=qtBxoxaBqDUw@mail.gmail.com>
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera> <_H4l51C1wXN.A.yDC.yGuqNB@chimera>
 <BANLkTimeaHwBiZoz=isCM=qtBxoxaBqDUw@mail.gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Sun, 17 Apr 2011 20:37:39 +0200
X-Google-Sender-Auth: IIzqO1ju4mtTaWyht4qpTGex1tE
Message-ID: <BANLkTi=1jO73DXDTD50bVpU82qphVKmRCw@mail.gmail.com>
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 7:03 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Apr 17, 2011 at 5:57 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.38.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=32982
> > Subject         : Kernel locks up a few minutes after boot
> > Submitter       : Bart Van Assche <bart.vanassche@gmail.com>
> > Date            : 2011-04-10 19:55 (8 days old)
>
> Is this machine running a RAID5 setup or something like that?
>
> There is a known interaction with the new block layer plugging code
> and MD. The "hung task" report in that bugzilla looks very much like
> that issue. And you do have "root=/dev/md0", so clearly there's some
> md thing going on.
>
> And bisecting might not work all that well for it, because I suspect
> it ends up being very much a matter of IO patterns how it triggers.
>
> Neil supposedly has a patch for it, but I haven't seen it yet. Neil, Jens?

(converted top-posting into bottom-posting)

Hello Linus,

On the system on which bug #32982 has been triggered md0, md1 and md2
have been configured as two-disk RAID1 (mirroring).

I've done my best to trigger enough I/O in order to obtain reliable
bisect results. A difficulty I encountered during bisecting though was
that I encountered unbootable kernels (all skipped revisions).

Bart.
