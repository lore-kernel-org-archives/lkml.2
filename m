Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab2KCTQJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 15:16:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57957 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab2KCTQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 15:16:04 -0400
Date: Sat, 03 Nov 2012 15:16:02 -0400 (EDT)
Message-Id: <20121103.151602.1818450049632367167.davem@davemloft.net>
To: xtfeng@gmail.com
Cc: linux-kernel@vger.kernel.org, dannyfeng@tencent.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] drivers/net: use tasklet_kill in device remove/close
 process
From: David Miller <davem@davemloft.net>
In-Reply-To: <1351679397-26994-1-git-send-email-xtfeng@gmail.com>
References: <1351679397-26994-1-git-send-email-xtfeng@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaotian Feng <xtfeng@gmail.com>
Date: Wed, 31 Oct 2012 18:29:57 +0800

> Some driver uses tasklet_disable in device remove/close process,
> tasklet_disable will inc tasklet->count and return. If the tasklet
> is not handled yet because some softirq pressure, the tasklet will
> placed on the tasklet_vec, never have a chance to excute. This might
> lead to ksoftirqd heavy loaded, wakeup with pending_softirq, but
> tasklet is disabled. tasklet_kill should be used in this case.
> 
> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>

Applied.
