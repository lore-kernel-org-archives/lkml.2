Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab0EPHQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 03:16:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53521
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752804Ab0EPHQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 03:16:44 -0400
Date: Sun, 16 May 2010 00:16:52 -0700 (PDT)
Message-Id: <20100516.001652.267947899.davem@davemloft.net>
To: tj@kernel.org
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk, bzolnier@gmail.com
Subject: Re: [PATCH 4/8] block: use struct parsed_partitions *state
 universally in partition check code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1273946974-29131-5-git-send-email-tj@kernel.org>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
	<1273946974-29131-5-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Sat, 15 May 2010 20:09:30 +0200

> Make the following changes to partition check code.
> 
> * Add ->bdev to struct parsed_partitions.
> 
> * Introduce read_part_sector() which is a simple wrapper around
>   read_dev_sector() which takes struct parsed_partitions *state
>   instead of @bdev.
> 
> * For functions which used to take @state and @bdev, drop @bdev.  For
>   functions which used to take @bdev, replace it with @state.
> 
> * While updating, drop superflous checks on NULL state/bdev in ldm.c.
> 
> This cleans up the API a bit and enables better handling of IO errors
> during partition check as the generic partition check code now has
> much better visibility into what went wrong in the low level code
> paths.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
