Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2GIHNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 03:13:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53583 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2GIHNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 03:13:09 -0400
Date: Mon, 09 Jul 2012 00:13:08 -0700 (PDT)
Message-Id: <20120709.001308.1467096850382631360.davem@davemloft.net>
To: ddaney.cavm@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        david.daney@cavium.com
Subject: Re: [PATCH] netdev/phy: Fixup lockdep warnings in mdio-mux.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1341439576-1413-1-git-send-email-ddaney.cavm@gmail.com>
References: <1341439576-1413-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney.cavm@gmail.com>
Date: Wed,  4 Jul 2012 15:06:16 -0700

> From: David Daney <david.daney@cavium.com>
> 
> With lockdep enabled we get:
 ...
> This is a false positive, since we are indeed using 'nested' locking,
> we need to use mutex_lock_nested().
> 
> Now in theory we can stack multiple MDIO multiplexers, but that would
> require passing the nesting level (which is difficult to know) to
> mutex_lock_nested().  Instead we assume the simple case of a single
> level of nesting.  Since these are only warning messages, it isn't so
> important to solve the general case.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

Applied to 'net', thanks.
