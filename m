Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048Ab2EIJXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:23:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35707 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758956Ab2EIJXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:23:14 -0400
Date: Wed, 9 May 2012 17:30:16 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jeff Garzik <jeff@garzik.org>, Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
Message-ID: <20120509093016.GA12754@gmail.com>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	Jeff Garzik <jeff@garzik.org>, Zheng Liu <wenqing.lz@taobao.com>
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
 <4FAA02DA.3000201@gmail.com>
 <20120509061956.GA12329@gmail.com>
 <20120509082527.GA10674@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509082527.GA10674@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 04:25:27AM -0400, Christoph Hellwig wrote:
> On Wed, May 09, 2012 at 02:19:56PM +0800, Zheng Liu wrote:
> > disable FUA detection for SATA disk.  If FUA feature can be used, we
> > could disable io_barrier to improve the performance.  Now one solution
> 
> You can't run with -o nobarrier just because the driver/hardware support
> FUA.  However the implementation of -o barrier (aka REQ_FUA) is a lot
> more efficient if it is implemented.  If your workload has a high
> percentage of REQ_FUA requests it might be better to switch the disks to
> write through mode entirely.

Thanks for your advice.  Indeed, it is more efficient when data is
flushed with REQ_FUA, and this is the reason why I submit this patch.
IMHO, FUA provides a solution that we can get better performance in write
cache mode when we do many flush operations.  If I set the disk to write
through mode, I won't get this benefit.  Am I missing something?

Currently, the key issue is that we disable FUA detection for SATA disk.
We almost have no chance to change it because it is too complicated to
set libata_fua variable when this module is loaded.  So why not give
SATA disk an opportunity to enable this feature?  After all, there is a
lot of SATA disks that support this feature.

Regards,
Zheng
