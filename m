Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab0EPHS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 03:18:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55796
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753461Ab0EPHSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 03:18:54 -0400
Date: Sun, 16 May 2010 00:19:03 -0700 (PDT)
Message-Id: <20100516.001903.67915868.davem@davemloft.net>
To: tj@kernel.org
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk, bzolnier@gmail.com
Subject: Re: [PATCH 8/8] libata: implement on-demand HPA unlocking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1273946974-29131-9-git-send-email-tj@kernel.org>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
	<1273946974-29131-9-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Sat, 15 May 2010 20:09:34 +0200

> Implement ata_scsi_unlock_native_capacity() which will be called
> through SCSI layer when block layer notices that partitions on a
> device extend beyond the end of the device.  It requests EH to unlock
> HPA, waits for completion and returns the current device capacity.
> 
> This allows libata to unlock HPA on demand instead of having to decide
> whether to unlock upfront.  Unlocking on demand is safer than
> unlocking by upfront because some BIOSes write private data to the
> area beyond HPA limit.  This was suggested by Ben Hutchings.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Suggested-by: Ben Hutchings <ben@decadent.org.uk>

Acked-by: David S. Miller <davem@davemloft.net>
