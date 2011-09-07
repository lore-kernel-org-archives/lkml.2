Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab1IGRNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:13:44 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40464 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab1IGRNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:13:43 -0400
Date: Wed, 07 Sep 2011 13:12:17 -0400 (EDT)
Message-Id: <20110907.131217.2301665763990232637.davem@davemloft.net>
To: yong.zhang0@gmail.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        joe@perches.com, sparclinux@vger.kernel.org
Subject: Re: [PATCH 20/62] sparc: irq: Remove IRQF_DISABLED
From: David Miller <davem@davemloft.net>
In-Reply-To: <1315383059-3673-21-git-send-email-yong.zhang0@gmail.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
	<1315383059-3673-21-git-send-email-yong.zhang0@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 07 Sep 2011 10:12:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang0@gmail.com>
Date: Wed,  7 Sep 2011 16:10:17 +0800

> This flag is a NOOP and can be removed now.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

How are things working now, if that is the case?

Specifically in the ldc_bind() case, we're passing iRQF_DISABLED here
so that the IRQ is not turned on when we request the IRQ, we later do
enable_irq() on these after we've take the spinlock in this function.

The IRQ cannot be allowed to be delivered between the request_irq()
call and the enable_irq() calls.

This sequence is necessary to deal with some lock ordering issues.
