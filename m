Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab1JESSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 14:18:17 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52033 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932812Ab1JESSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 14:18:16 -0400
Message-ID: <1317838695.1782.43.camel@Joe-Laptop>
Subject: Re: [alternate PATCH] block: fix UUID string buffer length
From: Joe Perches <joe@perches.com>
To: Vivek Goyal <vgoyal@redhat.com>, Huang Ying <ying.huang@intel.com>
Cc: Will Drewry <wad@chromium.org>, Rabin Vincent <rabin@rab.in>,
        axboe@kernel.dk, linux-kernel@vger.kernel.org
Date: Wed, 05 Oct 2011 11:18:15 -0700
In-Reply-To: <20111005181131.GK30146@redhat.com>
References: <1317808364-21081-1-git-send-email-rabin@rab.in>
	 <CABqD9hYw3qcMpcjyEtvstYD-WRB=QkVPS5S0MBbah=veZv9E6A@mail.gmail.com>
	 <1317833310.1782.33.camel@Joe-Laptop> <20111005181131.GK30146@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-05 at 14:11 -0400, Vivek Goyal wrote:
> On Wed, Oct 05, 2011 at 09:48:30AM -0700, Joe Perches wrote:
> > The UUID string buffer is several bytes shorter than what is actually
> > required.  Fix it and remove the used once inline part_unpack_uuid,
> > use snprintf and printf extension %pU directly.
> > 
> > Based-on-a-patch-by: Rabin Vincent <rabin@rab.in>
> > cc: Will Drewry <wad@chromium.org>
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  block/genhd.c         |    8 +++++---
> >  include/linux/genhd.h |    6 ------
> >  2 files changed, 5 insertions(+), 9 deletions(-)
> > 
> > diff --git a/block/genhd.c b/block/genhd.c
> > index e2f6790..427c955 100644
> > --- a/block/genhd.c
> > +++ b/block/genhd.c
> > @@ -735,7 +735,7 @@ void __init printk_all_partitions(void)
> >  		struct hd_struct *part;
> >  		char name_buf[BDEVNAME_SIZE];
> >  		char devt_buf[BDEVT_SIZE];
> > -		u8 uuid[PARTITION_META_INFO_UUIDLTH * 2 + 1];
> > +		char uuid[sizeof("12345678-1234-1234-1234-123456789012")];
> 
> will following look better.
> 
> char uuid [PARTITION_META_INFO_UUIDLTH * 2 + 5]
> 
> 4 bytes for hyphen and 1 for NULL.

Perhaps include/linux/uuid.h could be extended to provide
some #defines for the various UUID lengths.
 


