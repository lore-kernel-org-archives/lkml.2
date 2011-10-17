Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1JQXBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 19:01:07 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:11329 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1JQXBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 19:01:05 -0400
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
Thread-Index: AQHMiwB5ssYxGyHyyU2tUZBy8HXDxZV+YdCA///RXnCAAtYrAP//mN2AgAB/eQCAAAbIcA==
Date: Mon, 17 Oct 2011 23:00:56 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA1D68C@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1318660132-21529-1-git-send-email-kys@microsoft.com>
	 <1318714047.7271.49.camel@dabdike.int.hansenpartnership.com>
	 <6E21E5352C11B742B20C142EB499E0481AA0FED0@TK5EX14MBXC128.redmond.corp.microsoft.com>
	 <1318859976.4794.8.camel@dabdike.int.hansenpartnership.com>
	 <6E21E5352C11B742B20C142EB499E0481AA15174@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <1318865202.4794.21.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1318865202.4794.21.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.72]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9HN1E4b003781



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Monday, October 17, 2011 11:27 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> linux-scsi@vger.kernel.org; hch@infradead.org; Haiyang Zhang
> Subject: RE: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of
> staging
> 
> On Mon, 2011-10-17 at 15:15 +0000, KY Srinivasan wrote:
> > This patch is against Greg's staging tree where recently I merged all
> > of the storage
> > drivers into a single driver. This change may not have percolated up
> > yet - Greg has
> > checked this into his staging tree though.
> 
> OK, that explains the difference.
> 
> > As I deal with the review comments now, do you want me to get these
> > changes
> > applied first to Greg's tree before you would consider moving this
> > driver to drivers/scsi
> > directory, or could you move the driver as it is in Greg's tree under
> > staging and I could give
> > you patches against the moved driver.
> 
> Either way is fine by me.  The best route for this is to get the staging
> update into Linus head, then work on the actual SCSI problems.  I'd like
> other SCSI people besides me to review it.
> 
> > > OK, so as I read the code, what it can't handle is fragments except at
> > > the ends.  As long as everything always transfers in multiples of 4k,
> > > the problem will never occur.  This means that all devices you present
> > > need to tell the OS they have 4k sectors.  I *think* you can do this by
> > > setting  blk_limits_io_min() in the driver ... but you'll have to test
> > > this.  The minimum sector size gets set also in sd.c when we probe the
> > > disk.  I think that won't override blk_limits_io_min(), but please test
> > > (we don't have any SCSI drivers which have ever used this setting).
> > >
> > > The way to test, is to read back the /sys/block/<dev>/queue/ settings
> > > when presenting a 512 byte sector disk.  (And the way to activate your
> > > bounce code would be to create a filesystem with a < PAGE_SIZE block
> > > size).
> >
> > Given that the bounce buffer handling code would typically
> > never be triggered, I not sure how useful it will be to try to get rid
> > of the bounce buffer
> > code using a feature that is not well tested.
> 
> As opposed to bounce buffer code which hasn't been well tested either if
> it can't be triggered.
> 
> >  In any event, I will try your suggestion though.
> 
> Just to be clear: Setting the minimum I/O size is completely well
> tested: it's how we handle 4k sector drives.  What hasn't been tested is
> the ability of the *driver* to enforce the minimum using
> blk_limits_io_min().  As long at that doesn't get overridden by sd when
> it sees a 512b drive, the rest of the block paths (those which actually
> enforce the minimum) have all been well tested.

I will work on addressing the issues you have raised and any other comments I might
get from the community. I will submit these patches to Greg and I will copy you and other
scsi maintainers as well. Once Greg's staging tree is synced with Linus' tree, then I will submit
the code for further review in preparation for moving the code out of staging.

Regards,

K. Y

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
