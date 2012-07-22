Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab2GVTpR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 15:45:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38228 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2GVTpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 15:45:15 -0400
Date: Sun, 22 Jul 2012 12:45:14 -0700 (PDT)
Message-Id: <20120722.124514.239340989320198501.davem@davemloft.net>
To: xufengzhang.main@gmail.com
Cc: vyasevich@gmail.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: Make "Invalid Stream Identifier" ERROR follows
 SACK when bundling
From: David Miller <davem@davemloft.net>
In-Reply-To: <1342677450-21810-1-git-send-email-xufengzhang.main@gmail.com>
References: <1342677450-21810-1-git-send-email-xufengzhang.main@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <xufengzhang.main@gmail.com>
Date: Thu, 19 Jul 2012 13:57:30 +0800

> When "Invalid Stream Identifier" ERROR happens after process the
> received DATA chunks, this ERROR chunk is enqueued into outqueue
> before SACK chunk, so when bundling ERROR chunk with SACK chunk,
> the ERROR chunk is always placed first in the packet because of
> the chunk's position in the outqueue.
> This violates sctp specification:
>     RFC 4960 6.5. Stream Identifier and Stream Sequence Number
>     ...The endpoint may bundle the ERROR chunk in the same
>     packet as the SACK as long as the ERROR follows the SACK.
> So we must place SACK first when bundling "Invalid Stream Identifier"
> ERROR and SACK in one packet.
> Although we can do that by enqueue SACK chunk into outqueue before
> ERROR chunk, it will violate the side-effect interpreter processing.
> It's easy to do this job when dequeue chunks from the outqueue,
> by this way, we introduce a flag 'has_isi_err' which indicate
> whether or not the "Invalid Stream Identifier" ERROR happens.
> 
> Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>

Can some SCTP experts please review this?
