Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088Ab0EMQiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:38:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab0EMQiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:38:14 -0400
Subject: Re: [PATCHSET] libata: implement ->set_capacity()
From: James Bottomley <James.Bottomley@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       ben@decadent.org.uk
In-Reply-To: <4BEC272E.10508@kernel.org>
References: <1273766206-17402-1-git-send-email-tj@kernel.org>
	 <1273766778.4353.200.camel@mulgrave.site>  <4BEC272E.10508@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 11:38:07 -0500
Message-ID: <1273768687.4353.235.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 18:22 +0200, Tejun Heo wrote:
> > Instead of just saying unlock the HPA and show me the new capacity
> > (with a rescan), you have to echo the right number of sectors to the
> > set_capacity variable.  Isn't a hpa_unlock libata specific attribute
> > better (you could even call BLKRRPART from the user context of the
> > write)?
> 
> Hmmm... I lost you.  What are you talking about?

Instead of making this a block sysfs attribute, since HPA is SATA only,
why not make it a libata attribute for the disk?

That way on unlock, you can unlock the HPA and then trigger a partition
rescan of the block device (BLKRRPART) ... this is an ioctl, so you need
user context, but you have it if you do it from the sysfs write routine.
This looks to be a lot simpler than threading it up through SCSI and
block.

James


