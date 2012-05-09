Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160Ab2EIMl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 08:41:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42000 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2EIMlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 08:41:25 -0400
Date: Wed, 9 May 2012 20:48:04 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jeff Garzik <jeff@garzik.org>, Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
Message-ID: <20120509124804.GA13329@gmail.com>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	Jeff Garzik <jeff@garzik.org>, Zheng Liu <wenqing.lz@taobao.com>
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
 <4FAA02DA.3000201@gmail.com>
 <20120509061956.GA12329@gmail.com>
 <20120509082527.GA10674@infradead.org>
 <20120509093016.GA12754@gmail.com>
 <20120509111243.GB29593@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509111243.GB29593@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 07:12:43AM -0400, Christoph Hellwig wrote:
> On Wed, May 09, 2012 at 05:30:16PM +0800, Zheng Liu wrote:
> > IMHO, FUA provides a solution that we can get better performance in write
> > cache mode when we do many flush operations.  If I set the disk to write
> > through mode, I won't get this benefit.  Am I missing something?
> 
> If you set the disk to write through mode you never have to flush the
> cache.  So as soonas your number of flushes gets close to the number of
> writes it tends to be a clear win - for ATA the tradeoff is even more in
> favour of write through because the flush command can't be queued yetin
> commonly available standards versions.  So if you have a workload that
> basically needs to flush out every write you win - if you have workloads
> where you have a lot more writes than cache flushes write back mode
> wins.

Thanks for your explanation.  It seems that there still has a problem.
If I set the disk to write through mode, I need to modify my application
to remove all of flush/sync operations.  It is unacceptable for us.

> > Currently, the key issue is that we disable FUA detection for SATA disk.
> > We almost have no chance to change it because it is too complicated to
> > set libata_fua variable when this module is loaded.  So why not give
> > SATA disk an opportunity to enable this feature?  After all, there is a
> > lot of SATA disks that support this feature.
> 
> I'm all in favour of your patch, I just wanted to point out that the
> argument in the description wasn't quite correct.

Thank you.  I will fix it.  :-)

Regards,
Zheng
