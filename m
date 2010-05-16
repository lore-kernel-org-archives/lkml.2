Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0EPHRf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 03:17:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53530
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752804Ab0EPHRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 03:17:33 -0400
Date: Sun, 16 May 2010 00:17:42 -0700 (PDT)
Message-Id: <20100516.001742.22051241.davem@davemloft.net>
To: tj@kernel.org
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk, bzolnier@gmail.com
Subject: Re: [PATCH 5/8] block: improve automatic native capacity unlocking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1273946974-29131-6-git-send-email-tj@kernel.org>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
	<1273946974-29131-6-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Sat, 15 May 2010 20:09:31 +0200

> Currently, native capacity unlocking is initiated only when a
> recognized partition extends beyond the end of the disk.  However,
> there are several other unhandled cases where truncated capacity can
> lead to misdetection of partitions.
> 
> * Partition table is fully beyond EOD.
> 
> * Partition table is partially beyond EOD (daisy chained ones).
> 
> * Recognized partition starts beyond EOD.
> 
> This patch updates generic partition check code such that all the
> above three cases are handled too.  For the first two, @state tracks
> whether low level partition check code tried to read beyond EOD during
> partition scan and triggers native capacity unlocking accordingly.
> The third is now handled similarly to the original unlocking case.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
