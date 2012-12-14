Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab2LNVMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 16:12:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367Ab2LNVMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 16:12:07 -0500
Date: Fri, 14 Dec 2012 16:11:59 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: martin.petersen@oracle.com, Kernel Team <kernel-team@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, jgarzik@redhat.com,
        JBottomley@Parallels.com, Milan Broz <mbroz@redhat.com>
Subject: Re: [v3.7 Regression]  [SCSI] sd: Implement support for WRITE SAME
Message-ID: <20121214211159.GA4204@redhat.com>
References: <50CB8C74.3090102@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CB8C74.3090102@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14 2012 at  3:30pm -0500,
Joseph Salisbury <joseph.salisbury@canonical.com> wrote:

> Hi Martin,
> 
> A bug was opened against the Ubuntu kernel[0].  After a kernel
> bisect, it was found that reverting the following commit resolved
> this bug:
> 
> commit 5db44863b6ebbb400c5e61d56ebe8f21ef48b1bd
> Author: Martin K. Petersen <martin.petersen@oracle.com>
> Date:   Tue Sep 18 12:19:32 2012 -0400
> [SCSI] sd: Implement support for WRITE SAME
> 
> The regression was introduced as of v3.7-rc7.
> 
> The bug can be reproduced with the following commands, which will
> operate on a virtual scsi_debug device, so they won't change any
> data on the test system. However, this will completely crash the
> system:
> 
> sudo modprobe scsi_debug
> sudo luksformat -t ext4 /dev/sdb <- Or whatever device gets assigned
> after inserting scsi_debug.
> sudo cryptsetup luksOpen /dev/sdb treasure
> 
> Everything works fine up to here, but the following will cause the crash:
> 
> sudo mount /dev/mapper/treasure /mnt
> 
> The bug can be reproduced on bare metal, in a VM and on i386 or amd64.
> 
> I see that you are the author of this patch, so I wanted to run this
> by you.  I was thinking of requesting a revert for v3.7, but I
> wanted to get your feedback first.
> 
> 
> Thanks,
> 
> Joe
> 
> 
> [0] https://bugs.launchpad.net/bugs/1089818

The WRITE SAME change was introduced long before v3.7-rc7.  I think your
bisect is somehow wrong.

Milan Broz recently pointed out issues he found with luks when using a
late 3.7-rc (rc7 afaik).  Linus fixed that issue with this commit (which
landed in the final v3.7):
http://git.kernel.org/linus/684c9aaebbb0ea3a9954

That may not be _the_ problem though.  But have you tried the final
v3.7?

Mike
