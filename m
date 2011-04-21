Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1DUROm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 13:14:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50165
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755127Ab1DUROj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 13:14:39 -0400
Date: Thu, 21 Apr 2011 10:14:04 -0700 (PDT)
Message-Id: <20110421.101404.02262055.davem@davemloft.net>
To: tj@kernel.org
Cc: jaxboe@fusionio.com, torvalds@linux-foundation.org, hch@lst.de,
        neilb@suse.de, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        kay.sievers@vrfy.org
Subject: Re: [PATCH 2/2] ide: unexport DISK_EVENT_MEDIA_CHANGE for ide-gd
 and ide-cd
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110421170925.GD15988@htj.dyndns.org>
References: <20110421170826.GC15988@htj.dyndns.org>
	<20110421170925.GD15988@htj.dyndns.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Thu, 21 Apr 2011 19:09:25 +0200

> check_events() implementations in both ide-gd and ide-cd are
> inadequate for in-kernel event polling.  Both generate media change
> events continuously when certain conditions are met causing infinite
> event loop between the driver and userland event handler.
> 
> As disk event now supports suppression of unlisted events, simply
> de-listing DISK_EVENT_MEDIA_CHANGE from disk->events resolves the
> problem.  Internal handling around media revalidation will behave the
> same while userland will fall back to userland event polling after
> detecting the device doesn't support disk events.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Jens Axboe <jaxboe@fusionio.com>

Acked-by: David S. Miller <davem@davemloft.net>
