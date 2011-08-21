Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1HUAcr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 20:32:47 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41640 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab1HUAcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 20:32:46 -0400
Date: Sat, 20 Aug 2011 17:31:33 -0700 (PDT)
Message-Id: <20110820.173133.1612902138924735868.davem@davemloft.net>
To: ian.campbell@citrix.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, mirq-linux@rere.qmqm.pl
Subject: Re: [PATCH] net: add APIs for manipulating skb page fragments.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1313771100-22993-1-git-send-email-ian.campbell@citrix.com>
References: <1313771100-22993-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 20 Aug 2011 17:31:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>
Date: Fri, 19 Aug 2011 17:25:00 +0100

> The primary aim is to add skb_frag_(ref|unref) in order to remove the use of
> bare get/put_page on SKB pages fragments and to isolate users from subsequent
> changes to the skb_frag_t data structure.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

You're going to have to protect all of the things using the interfaces
from linux/dma-mapping.h with CONFIG_HAS_DMA otherwise it won't build
on platforms like S390.
