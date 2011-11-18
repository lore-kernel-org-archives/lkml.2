Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab1KRX2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:28:24 -0500
Received: from mail3.microsoft.com ([131.107.115.214]:37861 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1KRX2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:28:22 -0500
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>
Subject: RE: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Thread-Topic: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Thread-Index: AQHMnj6gZ2NVqeJYKEyKywEkfms/G5Wx9nyA///jaKCAAZbjgP//5X5w
Date: Fri, 18 Nov 2011 23:28:19 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA6D4CC@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1320776028-29568-1-git-send-email-kys@microsoft.com>
	 <1321554393.3041.77.camel@dabdike.int.hansenpartnership.com>
	 <6E21E5352C11B742B20C142EB499E0481AA6D232@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <1321635631.3022.44.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1321635631.3022.44.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.35]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAINSXxT013754



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Friday, November 18, 2011 12:01 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; linux-
> scsi@vger.kernel.org; ohering@suse.com; hch@infradead.org
> Subject: RE: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of the
> staging area
> 
> On Fri, 2011-11-18 at 04:53 +0000, KY Srinivasan wrote:
> > > I still think you need to disable clustering and junk the bvec merge
> > > function.  Your object seems to be to accumulate in page size multiples
> > > (and not aggregate over this) ... that's what clustering is designed to
> > > do.
> >
> > As part of addressing your first round of comments, I experimented with your
> > suggestions and I could not get rid of the code that does the bounce buffer
> handling.
> > I could generate I/O patterns that would require bounce buffer handling with
> your
> > suggestions in place.
> 
> There are two separate things here.  One is the scatter gather list
> bounce buffer processing, which is a bit nasty, but if you want to use <
> 4kb block size filesystems, I suppose I have to accept that you need it
> (although since it's a global fault of the hypervisor, perhaps it should
> sit in the hypervisor interface layer, so that every SG based transport
> can use it).  The other is the biovec merge function addition.  The
> purpose of this function seems to be to ensure you get one SG entry for
> every page (if I read it right)?  In that case, you don't need any of
> this special casing.  The flag DISABLE_CLUSTERING achieves the same
> thing.

Thanks James. I will keep you posted on my progress on this issue.

Regards,

K. Y

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
