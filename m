Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab0EPHPp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 03:15:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53512
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121Ab0EPHPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 03:15:44 -0400
Date: Sun, 16 May 2010 00:15:52 -0700 (PDT)
Message-Id: <20100516.001552.85431321.davem@davemloft.net>
To: tj@kernel.org
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk, bzolnier@gmail.com
Subject: Re: [PATCH 3/8] block,ide: simplify bdops->set_capacity() to
 ->unlock_native_capacity()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1273946974-29131-4-git-send-email-tj@kernel.org>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
	<1273946974-29131-4-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Sat, 15 May 2010 20:09:29 +0200

> bdops->set_capacity() is unnecessarily generic.  All that's required
> is a simple one way notification to lower level driver telling it to
> try to unlock native capacity.  There's no reason to pass in target
> capacity or return the new capacity.  The former is always the
> inherent native capacity and the latter can be handled via the usual
> device resize / revalidation path.  In fact, the current API is always
> used that way.
> 
> Replace ->set_capacity() with ->unlock_native_capacity() which take
> only @disk and doesn't return anything.  IDE which is the only current
> user of the API is converted accordingly.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
