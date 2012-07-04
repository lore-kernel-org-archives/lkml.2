Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630Ab2GDG5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:57:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38561 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933360Ab2GDG5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:57:49 -0400
Date: Wed, 4 Jul 2012 15:06:04 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
Message-ID: <20120704070604.GA17769@gmail.com>
Mail-Followup-To: Michael Tokarev <mjt@tls.msk.ru>,
	Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
 <20120703090441.GA4804@gmail.com>
 <4FF351F8.1000003@msgid.tls.msk.ru>
 <20120704024715.GA17095@gmail.com>
 <4FF3E478.50609@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF3E478.50609@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 10:36:40AM +0400, Michael Tokarev wrote:
> > Thanks for the reply.  Indeed it is quite a big project but we enable
> > FUA feature for SAS disk.  Is there any differences?
> 
> Yes, there's a very big difference with SAS disks.  Even in parallel SCSI
> world DPO/FUA has been enabled since the day it has been implemented IIRC,
> because, apparently, hardware raid controllers enabled it too.  In other
> words, it has been tested and proved to be working even before linux
> implementation.  When first SAS disks started appearing, DPO/FUA were
> enabled for them in linux already -- at that time any breakage were
> solely due to the particular disk model, and were easy to blacklist,
> if necessary, since only a few disk models were in production.
> 
> With SATA disks, initial hardware implementation proved to be more
> non-functional than functional, ie, initially there were more drives
> with non-working FUA.  I have a few not-so-old SATA drives here which
> behaves strangely when FUA is enabled (I don't remember exact details,
> but I had to disable FA again after I tried to enable it once, the
> system started behaving not as good as before).  So, for SATA drives,
> we've exactly the opposite picture: we've some proof that "generally,
> drives dislikes FUA", and now when fua has been disabled for a lot
> of drives and users, turning it on by default needs lots of testing.
> 
> But I ask again: what is the benefit of turning FUA on to start with?

Thanks for your clarification. :-)

Turning FUA on can reduce the overhead of flushes AFAIK.  In our product
system we have a lot of SATA disks with FUA, but we must add a boot
parameter 'libata.fua=1' to enable it.  Meanwhile there already has a
number of SATA disks that have supported this feature.  So I think maybe
we can enable it.

Regards,
Zheng
