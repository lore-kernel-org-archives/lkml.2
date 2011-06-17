Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab1FQT2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 15:28:35 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:47531 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932949Ab1FQT2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 15:28:30 -0400
Date: Fri, 17 Jun 2011 15:28:00 -0400 (EDT)
Message-Id: <20110617.152800.1945884789188813626.davem@davemloft.net>
To: shved@ispras.ru
Cc: hjlipp@web.de, tilman@imap.cc, isdn@linux-pingi.de,
        gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH] gigaset: call module_put before restart of if_open()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1308327913-23220-2-git-send-email-shved@ispras.ru>
References: <1308327913-23220-1-git-send-email-shved@ispras.ru>
	<1308327913-23220-2-git-send-email-shved@ispras.ru>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 17 Jun 2011 12:28:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Shved <shved@ispras.ru>
Date: Fri, 17 Jun 2011 20:25:11 +0400

> if_open() calls try_module_get(), and after an attempt to lock a mutex
> the if_open() function may return -ERESTARTSYS without
> putting the module.  Then, when if_open() is executed again,
> try_module_get() is called making the reference counter of THIS_MODULE
> greater than one at successful exit from if_open().  The if_close()
> function puts the module only once, and as a result it can't be
> unloaded.
> 
> This patch adds module_put call before the return from if_open().
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Pavel Shved <shved@ispras.ru>

Applied.
