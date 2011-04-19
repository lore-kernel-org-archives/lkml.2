Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1DSQjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:39:55 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37315 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1DSQjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:39:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=uSXtcMuwJPTCchTMkH/Fv/OhAxfOvGxvshwtIw2ktFyWH6LjBa8i/XQW7cvIWKvW5O
         XRZYxoCJFDF5QnmGFttdmNVDPUNh1plKnkVy71ORWLXtXubD7U7pQUM8zU+9EeEMhftA
         rhE7Ae7OSFpLJi4lyG08dhqWQyQ2mVFT18VJc=
MIME-Version: 1.0
In-Reply-To: <1303183934.2585.12.camel@obelisk.thedillows.org>
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera> <_H4l51C1wXN.A.yDC.yGuqNB@chimera>
 <BANLkTimeaHwBiZoz=isCM=qtBxoxaBqDUw@mail.gmail.com> <BANLkTi=1jO73DXDTD50bVpU82qphVKmRCw@mail.gmail.com>
 <4DAC2429.5000105@fusionio.com> <BANLkTinCWWYqnksxevho9TN3u6ZC_Rjzwg@mail.gmail.com>
 <1303183934.2585.12.camel@obelisk.thedillows.org>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 19 Apr 2011 18:39:32 +0200
X-Google-Sender-Auth: 85Ee8MoG-0B-qOPsPRQjDpDuL1U
Message-ID: <BANLkTi=mJgBb8Fv9xnN+qP3CWM9vkNKMyg@mail.gmail.com>
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
To: David Dillow <dave@thedillows.org>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 5:32 AM, David Dillow <dave@thedillows.org> wrote:
>
> On Mon, 2011-04-18 at 20:21 +0200, Bart Van Assche wrote:
> > On Mon, Apr 18, 2011 at 1:44 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
> > > Bart, can you try and pull:
> > >
> > > git://git.kernel.dk/linux-2.6-block.git for-linus
> > >
> > > into Linus' tree and see if that works? This has, among other things,
> > > Neils fixes for MD.
> >
> > md seems to work stable with the resulting tree, but it looks there is
> > a performance regression in the block layer not related to the md
> > issue. If I run a small block IOPS test on a block device created by
> > ib_srp (NOOP scheduler) I see about 11% less IOPS than with 2.6.38.3
> > (155.000 IOPS with 2.6.38.3 and 140.000 IOPS with 2.6.39-rc3+).
>
> The mapping code for ib_srp changed in 2.6.39-rc1, but it showed
> improved IOPS for a similar setup in my testing so I'd be surprised if
> it is the culprit. Still, it wouldn't hurt to check. Do you have time to
> try the new ib_srp code with 2.6.38.3 to eliminate it from the equation?

Hello Dave,

I just ran a test with the most important 2.6.39-specific ib_srp
commits reverted but that didn't yield a measurable performance
difference for this specific test:

$ git show --format=format:%s 7f9e5c48c1078507747434d4c182ab10925bf98a
be8b981453a4904399cb090c1660618e250092d8
c07d424d6118d528ef71b22b7424bfc359c307a5
8f26c9ff9cd0317ad867bce972f69e0c6c2cbe3c
961e0be89a5120a1409ebc525cca6f603615a8a8
8c4037b501acd2ec3abc7925e66af8af40a2da9d | grep '^IB'
IB: Increase DMA max_segment_size on Mellanox hardware
IB/srp: try to use larger FMR sizes to cover our mappings
IB/srp: add support for indirect tables that don't fit in SRP_CMD
IB/srp: rework mapping engine to use multiple FMR entries
IB/srp: move IB CM setup completion into its own function
IB/srp: always avoid non-zero offsets into an FMR

Bart.
