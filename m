Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab1HSDiC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 23:38:02 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53711 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1HSDiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 23:38:00 -0400
Date: Thu, 18 Aug 2011 20:34:47 -0700 (PDT)
Message-Id: <20110818.203447.462383652600224162.davem@davemloft.net>
To: davidb@codeaurora.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: of_iomap() matched with plan iounmap()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110818170226.GA16721@huya.qualcomm.com>
References: <20110818170226.GA16721@huya.qualcomm.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 18 Aug 2011 20:34:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brown <davidb@codeaurora.org>
Date: Thu, 18 Aug 2011 10:02:26 -0700

> The SPARC target contains of_ioremap() and of_iounmap(), which various
> drivers use (generally inside of CONFIG_SBUS).
> 
> include/linux/of_address.h contains a definition for of_iomap(), but
> not corresponding unmap call.  Code using this calls the regular
> iounmap().
> 
> Is it safe to assume that of_iomap() will always be based on ioremap()
> and therefore it is safe to use iounmap(), or would it be better to
> define another name for drivers to use as the inverse of of_iomap().
> I'm not sure what to call it, since of_iounmap() is already taken by
> SPARC.

It's better to define a matching of_iounmap() interface, even if for
now it is exactly iounmap()
