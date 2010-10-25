Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab0JYU1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 16:27:50 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:17631 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863Ab0JYU1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 16:27:48 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        "Benesh, Scott" <scott.benesh@hp.com>
CC: "axboe@kernel.dk" <axboe@kernel.dk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "thenzl@redhat.com" <thenzl@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 25 Oct 2010 20:26:54 +0000
Subject: RE: [PATCH 01/13] cciss: remove controllers supported by hpsa
Thread-Topic: [PATCH 01/13] cciss: remove controllers supported by hpsa
Thread-Index: Act0gIWIT/w1BM3LR9a4S8qB+izrWgAAKt/Q
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77887D0E280BD9@GVW0547EXC.americas.hpqcorp.net>
References: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
	 <20101008200606.24279.37953.stgit@beardog.cce.hp.com>
 <1288037360.5487.730.camel@mulgrave.site>
In-Reply-To: <1288037360.5487.730.camel@mulgrave.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9PKS2A8005579



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Monday, October 25, 2010 3:09 PM
> To: Stephen M. Cameron
> Cc: axboe@kernel.dk; akpm@linux-foundation.org; thenzl@redhat.com;
> Miller, Mike (OS Dev); linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 01/13] cciss: remove controllers supported by hpsa
> 
> On Fri, 2010-10-08 at 15:06 -0500, Stephen M. Cameron wrote:
> > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> >
> > We would prefer not to have any overlap between the two drivers.
> > Remove the cciss_allow_hpsa option, as it it is no longer needed.
> >
> > Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > ---
> >  drivers/block/cciss.c |   38 +-------------------------------------
> >  1 files changed, 1 insertions(+), 37 deletions(-)
> >
> > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> > index 5e4fadc..ca900ea 100644
> > --- a/drivers/block/cciss.c
> > +++ b/drivers/block/cciss.c
> > @@ -66,12 +66,6 @@ MODULE_SUPPORTED_DEVICE("HP Smart Array
> Controllers");
> >  MODULE_VERSION("3.6.26");
> >  MODULE_LICENSE("GPL");
> >
> > -static int cciss_allow_hpsa;
> > -module_param(cciss_allow_hpsa, int, S_IRUGO|S_IWUSR);
> > -MODULE_PARM_DESC(cciss_allow_hpsa,
> > -	"Prevent cciss driver from accessing hardware known to be "
> > -	" supported by the hpsa driver");
> > -
> >  #include "cciss_cmd.h"
> >  #include "cciss.h"
> >  #include <linux/cciss_ioctl.h>
> > @@ -98,18 +92,6 @@ static const struct pci_device_id
> cciss_pci_device_id[] = {
> >  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C,
> 0x3215},
> >  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C,
> 0x3237},
> >  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C,
> 0x323D},
> > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> 0x3241},
> > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> 0x3243},
> > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> 0x3245},
> > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> 0x3247},
> > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> 0x3249},
> > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> 0x324A},
> > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> 0x324B},
> > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> 0x3250},
> > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> 0x3251},
> > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> 0x3252},
> > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> 0x3253},
> > -	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C,
> 0x3254},
> 
> This hunk conflicts with the update Mike Miller sent
> 
> commit 6362beea8914cbd4630ccde3617d944aeca2d48f
> Author: Mike Miller <mike.miller@hp.com>
> Date:   Tue Oct 19 09:40:34 2010 +0200
> 
>     cciss: fix PCI IDs for new Smart Array controllers
> 
> And which is now mainline.
> 
> James

I guess I'm the one who jumped the gun on the patch I sent to correct those PCI IDs. I suppose it would be preferable to have no overlapping support between cciss and hpsa. With the distros it's a little easier to draw a line in the sand (or is it?). On some distros it seems migration is impossible, on others it's fairly simple.

I guess my point is what do users want? Does a significant number want to use upstream kernels but they still require cciss? Should we force them to go to hpsa? Or should they just add whatever ID they want and go on with life?

Maybe if we broke out the PCI IDs into a separate include file for both drivers??? Does that help? Probably not. I saw this coming long ago but I still don't know the answer. Any ideas, comments, suggestions, flames?

-- mikem

> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
