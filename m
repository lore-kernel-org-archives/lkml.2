Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab1JQPPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:15:14 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:38915 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1JQPPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:15:11 -0400
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of staging
Thread-Topic: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of staging
Thread-Index: AQHMiwB5ssYxGyHyyU2tUZBy8HXDxZV+YdCA///RXnCAAtYrAP//mN2A
Date: Mon, 17 Oct 2011 15:15:09 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA15174@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1318660132-21529-1-git-send-email-kys@microsoft.com>
	 <1318714047.7271.49.camel@dabdike.int.hansenpartnership.com>
	 <6E21E5352C11B742B20C142EB499E0481AA0FED0@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <1318859976.4794.8.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1318859976.4794.8.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.34]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9HFFU6S001246



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Monday, October 17, 2011 10:00 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> linux-scsi@vger.kernel.org; hch@infradead.org; Haiyang Zhang
> Subject: RE: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of
> staging
> 
> On Sun, 2011-10-16 at 03:01 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> > > Sent: Saturday, October 15, 2011 5:27 PM
> > > To: KY Srinivasan
> > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org;
> ohering@suse.com;
> > > linux-scsi@vger.kernel.org; hch@infradead.org; Haiyang Zhang
> > > Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of
> > > staging
> > >
> > > On Fri, 2011-10-14 at 23:28 -0700, K. Y. Srinivasan wrote:
> > > > In preparation for moving the storage driver out of staging, seek community
> > > > review of the storage  driver code.
> > >
> > > That's not exactly a very descriptive commit message for me to put into
> > > SCSI.  It doesn't have to be huge, just something like "driver to enable
> > > hyperv windows guest on Linux" or something.
> >
> > Sorry about the commit message. I will have a more descriptive message in the
> next
> > submission.
> >
> > >
> > >
> > > >  drivers/scsi/Kconfig             |    7 +
> > > >  drivers/scsi/Makefile            |    3 +
> > > >  drivers/scsi/storvsc_drv.c       | 1480
> > > ++++++++++++++++++++++++++++++++++++++
> > > >  drivers/staging/hv/Kconfig       |    6 -
> > > >  drivers/staging/hv/Makefile      |    2 -
> > > >  drivers/staging/hv/storvsc_drv.c | 1480 --------------------------------------
> > > >  6 files changed, 1490 insertions(+), 1488 deletions(-)
> > >
> > > What tree is this against?  The hv/storvsc_drv.c in upstream only has
> > >
> > > jejb@dabdike> wc -l drivers/staging/hv/storvsc_drv.c
> > > 792 drivers/staging/hv/storvsc_drv.c
> > >
> > > i.e. whatever you're sending is double the length (and obviously I have
> > > trouble applying the patch.
> >
> > This patch  moves the file from drivers/staging/hv/ directory to the
> > drivers/scsi directory; hence double the length.
> 
> No, that's not it.  Look again: the storvsc_drv.c in staging is removing
> 1480 lines, but in git head, this file is only 792 lines long ... is
> there an alternative tree with the rest in?

This patch is against Greg's staging tree where recently I merged all of the storage
drivers into a single driver. This change may not have percolated up yet - Greg has
checked this into his staging tree though.

As I deal with the review comments now, do you want me to get these changes
applied first to Greg's tree before you would consider moving this driver to drivers/scsi
directory, or could you move the driver as it is in Greg's tree under staging and I could give
you patches against the moved driver.

> 
> The point I'm making is that the staging file you're modifying isn't the
> one I see in Linus' git head, so which git tree is it in (I assume it's
> somewhere waiting for the merge window)?
> 
> [...]
> > > The bounce buffer handling for discontiguous sg lists is a complete
> > > nightmare.  And can't you just fix the hypervisor instead of pulling
> > > this level of nastiness in the driver, I mean really, the last piece of
> > > real SCSI hardware that failed this badly was produced in the dark ages.
> >
> > The restrictions (as they are) are really from the windows host side
> > and for what it is
> > worth, I have never seen this code triggered at least for I/O
> > initiated by the file system.
> >
> >
> > > Assuming the answer is "no", I really think you need to set the minimum
> > > block size to 4k, which will completely avoid the situation.
> >
> > I would love to get rid of the bounce buffer handling code by ensuring
> > that the
> > upper level code would never present scatter gather lists that would
> > trigger bounce buffer
> > handling code. How would I accomplish that.
> 
> OK, so as I read the code, what it can't handle is fragments except at
> the ends.  As long as everything always transfers in multiples of 4k,
> the problem will never occur.  This means that all devices you present
> need to tell the OS they have 4k sectors.  I *think* you can do this by
> setting  blk_limits_io_min() in the driver ... but you'll have to test
> this.  The minimum sector size gets set also in sd.c when we probe the
> disk.  I think that won't override blk_limits_io_min(), but please test
> (we don't have any SCSI drivers which have ever used this setting).
> 
> The way to test, is to read back the /sys/block/<dev>/queue/ settings
> when presenting a 512 byte sector disk.  (And the way to activate your
> bounce code would be to create a filesystem with a < PAGE_SIZE block
> size).

Given that the bounce buffer handling code would typically
never be triggered, I not sure how useful it will be to try to get rid of the bounce buffer
code using a feature that is not well tested. In any event, I will try your suggestion though. 

Regards,

K. Y 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
