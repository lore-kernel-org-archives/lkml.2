Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476Ab0EMQzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:55:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:47113 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab0EMQzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:55:08 -0400
Message-ID: <4BEC2ED7.9080001@kernel.org>
Date: Thu, 13 May 2010 18:54:47 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       ben@decadent.org.uk
Subject: Re: [PATCHSET] libata: implement ->set_capacity()
References: <1273766206-17402-1-git-send-email-tj@kernel.org>	 <1273766778.4353.200.camel@mulgrave.site>  <4BEC272E.10508@kernel.org> <1273768687.4353.235.camel@mulgrave.site>
In-Reply-To: <1273768687.4353.235.camel@mulgrave.site>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 16:54:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/13/2010 06:38 PM, James Bottomley wrote:
> Instead of making this a block sysfs attribute, since HPA is SATA only,
> why not make it a libata attribute for the disk?
> 
> That way on unlock, you can unlock the HPA and then trigger a partition
> rescan of the block device (BLKRRPART) ... this is an ioctl, so you need
> user context, but you have it if you do it from the sysfs write routine.
> This looks to be a lot simpler than threading it up through SCSI and
> block.

This doesn't have anything to do with sysfs.  It's called from block
partition scan code when it detects a partition extends beyond the end
of the device.  No user intervention at all and the mechanism has been
there for quite some years and possibly predates sysfs.  Am I being
really slow or are you looking at something else?

Thanks.

-- 
tejun
