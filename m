Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab2K2Irh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:47:37 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47539 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2K2Irg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:47:36 -0500
X-AuditID: 9c930197-b7bd3ae000003f1c-10-50b721277849
Date: Thu, 29 Nov 2012 17:47:34 +0900
From: Minchan Kim <minchan@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Jerome Marchand <jmarchan@redhat.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>, Tomas M <tomas@slax.org>,
        Mihail Kasadjikov <hamer.mk@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] zram: Fix use-after-free bug in disk write case
Message-ID: <20121129084734.GA11840@blaptop>
References: <1354175106-30679-1-git-send-email-ngupta@vflare.org>
 <20121129075503.GB5564@bbox>
 <50B7205E.20607@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B7205E.20607@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 12:44:14AM -0800, Nitin Gupta wrote:
> On 11/28/2012 11:55 PM, Minchan Kim wrote:
> >Hi Nitin,
> >
> >On Wed, Nov 28, 2012 at 11:45:06PM -0800, Nitin Gupta wrote:
> >>Changelog v2 vs v1:
> >>  - Changelog message now correctly explains the problem
> >>
> >>Fixes a bug introduced by commit c8f2f0db1 ("zram: Fix handling
> >>of incompressible pages") which caused a freed buffer to be used
> >>in case a partial write (non PAGE_SIZED) request is received and
> >>the data is found to be incompressible.
> >>
> >>Fixes bug 50081:
> >>https://bugzilla.kernel.org/show_bug.cgi?id=50081
> >
> >When I saw https://bugzilla.kernel.org/attachment.cgi?id=85571, it was
> >swap write usecase so parital write can not happen.
> >So this bug isn't related to freed buffer caused by partial write.
> >
> >This bug is related to unmapped buffer access.
> >
> >1) user_mem = kmap_atomic
> >2) uncmem = usermem
> >3) compress
> >4) kunmap_atomic(usermem) <-- So, uncmem is dangling.
> >5) src = uncmem; <-- So, src is dangling.
> >6) memcpy(cmem, src, clen) <-- HIT
> >
> 
> This is what I had in mind, still missed it in description. Will
> repost with updated description as below:
> 
> zram: fix invalid memory references during disk write
> 
> Fixes a bug introduced by commit c8f2f0db1 ("zram: Fix handling
> of incompressible pages") which caused invalid memory references
> during disk write. Invalid references could occur in two cases:
>  - Incoming data expands on compression: In this case, reference was
> made to kunmap()'ed bio page.
>  - Partial (non PAGE_SIZE) write with incompressible data: In this
> case, reference was made to a kfree()'ed buffer.
> 
> 
> Please let me know if the description looks okay.

Looks good to me.
Thanks!
-- 
Kind regards,
Minchan Kim
