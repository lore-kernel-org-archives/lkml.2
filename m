Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab1JDPGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:06:53 -0400
Received: from websrv.saout.de ([78.46.99.52]:41727 "EHLO websrv.saout.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302Ab1JDPGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:06:52 -0400
Subject: Re: [dm-devel] Block regression since 3.1-rc3
From: Christophe Saout <christophe@saout.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
In-Reply-To: <x49pqicnapu.fsf@segfault.boston.devel.redhat.com>
References: <1317397918.27140.15.camel@localhost>
	 <x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
	 <1317729761.25998.4.camel@localhost>
	 <x49pqicnapu.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 17:06:09 +0200
Message-ID: <1317740769.25998.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

> > Line 323 is this one: BUG_ON(!rq->bio || rq->bio != rq->biotail);
> >
> > The bug is not specific to GFS2, I also get it when using an ext3 mount
> > on that multipath storage pool when writing to a file.
> 
> Great, thanks!  I tried ext3 and ext4 as well, and was unable to trigger
> this problem.  I setup a linear volume on top of a multipath device.  Is
> that the configuration you are using?  Anyway, this may be enough to get
> me on the right path...

Yes - the device-mapper tables looks like:

vserv81:/root # dmsetup table RAID_A-test.root
0 20971520 linear 253:6 384

(this is one the FS which causes the crash when mounting via ext3)

And 253:6 is the multipath device:

vserv81:/root # dmsetup table 3600d023100065bef0000000009f337c0
0 15626018816 multipath 0 0 2 1 round-robin 0 1 1 8:16 1000 round-robin 0 1 1 8:48 1000 

And 8:16, 8:48 are two qla2xxx FC ports.

Cheers,
	Christophe


