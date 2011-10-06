Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab1JFR6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:58:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49288 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1JFR6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:58:19 -0400
Date: Thu, 6 Oct 2011 19:58:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Barry Song <21cnbao@gmail.com>
Cc: Luca Tettamanti <kronos.it@gmail.com>, Barry Song <Barry.Song@csr.com>,
        frank.hofmann@tomtom.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com, rjw@sisk.pl,
        linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] PM: HIBERNATION: add resume_wait param to support
	MMC-like devices as resume file
Message-ID: <20111006175818.GB9886@atrey.karlin.mff.cuni.cz>
References: <1317288548-19560-1-git-send-email-Barry.Song@csr.com> <CAKPcRGr3EzjS2es6HniuQziEivpsfH2r=d_Y=nkrsFW59g6xSw@mail.gmail.com> <CAGsJ_4zjRpEx_yLwXx74uipPN-Q2hun3AdLxKw2EYOy00cDm3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4zjRpEx_yLwXx74uipPN-Q2hun3AdLxKw2EYOy00cDm3Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2011/9/29 Luca Tettamanti <kronos.it@gmail.com>:
> > On Thu, Sep 29, 2011 at 11:29 AM, Barry Song <Barry.Song@csr.com> wrote:
> >> From: Barry Song <baohua.song@csr.com>
> >>
> >> Some devices like mmc are async detected very slow. For example,
> >> drivers/mmc/host/sdhci.c launchs a 200ms delayed work to detect
> >> mmc partitions then add disk.
> >>
> >> we do have wait_for_device_probe and scsi_complete_async_scans
> >> before calling swsusp_check, but it is not enough to wait mmc.
> >>
> >> This patch adds resumewait kernel param just like rootwait so
> >> that we have enough time to wait mmc ready. The differene is
> >> here we wait for resume partition but rootwait waits for rootfs
> >> partition.
> >
> > I assume that such a device would need "rootwait" to boot in the first
> > place; why don't you "overload" the param to also enable waiting in
> > the resume path?
> 
> not real. for an embedded product, the type of the rootfs, the place
> of the rootfs  and the way to mount rootfs are pretty flexible.
> even though both rootfs and resume file use mmc, they will be in
> different partitions at least. so i don't think rootwait can overload
> resumewait.

It would be good to at least model it the same way. rootdelay allows
you to specify time, which is important for USB devices...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
