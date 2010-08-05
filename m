Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab0HEJRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:17:15 -0400
Received: from smtp-out-118.synserver.de ([212.40.180.118]:1077 "EHLO
	smtp-out-117.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754153Ab0HEJRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:17:12 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 17503
Date: Thu, 5 Aug 2010 11:17:04 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Tejun Heo <htejun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH RESEND block#for-2.6.36] block_dev: always serialize
 exclusive open attempts
Message-ID: <20100805091704.GA1772@arch.tripp.de>
References: <2dWFdr9kTFM.A.P0D.spXVMB@chimera>
 <AANLkTimcH7+Bq1UEbaSU7SQpzArPgmSLegiqE13V8=CF@mail.gmail.com>
 <4C56F30D.3020304@kernel.org>
 <4C598E6B.7050405@gmail.com>
 <4C5A7E33.3060101@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C5A7E33.3060101@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 11:02:43AM +0200, Jens Axboe wrote:
> On 2010-08-04 17:59, Tejun Heo wrote:
> > bd_prepare_to_claim() incorrectly allowed multiple attempts for
> > exclusive open to progress in parallel if the attempting holders are
> > identical.  This triggered BUG_ON() as reported in the following bug.
> > 
> >   https://bugzilla.kernel.org/show_bug.cgi?id=16393
> > 
> > __bd_abort_claiming() is used to finish claiming blocks and doesn't
> > work if multiple openers are inside a claiming block.  Allowing
> > multiple parallel open attempts to continue doesn't gain anything as
> > those are serialized down in the call chain anyway.  Fix it by always
> > allowing only single open attempt in a claiming block.
> > 
> > This problem can easily be reproduced by adding a delay after
> > bd_prepare_to_claim() and attempting to mount two partitions of a
> > disk.
> > 
> > stable: only applicable to v2.6.35
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> > Cc: stable@kernel.org
> 
> Thanks Tejun, applied.

It's already in mainline:
e75aa85892b2ee78c79edac720868cbef16e62eb

-- 
»A man who doesn't know he is in prison can never escape.«
William S. Burroughs
