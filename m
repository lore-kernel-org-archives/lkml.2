Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2E2V2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 17:28:51 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60021 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab2E2V2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 17:28:49 -0400
Date: Tue, 29 May 2012 17:28:43 -0400 (EDT)
Message-Id: <20120529.172843.1775456038320356018.davem@davemloft.net>
To: florian@openwrt.org
Cc: devendra.aaru@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r6040: disable pci device if the subsequent calls
 (after pci_enable_device) fails
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120529.172229.277102319861990758.davem@davemloft.net>
References: <1338206223-26781-1-git-send-email-devendra.aaru@gmail.com>
	<1659482.3g1Zl6FDuM@flexo>
	<20120529.172229.277102319861990758.davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 29 May 2012 14:28:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 29 May 2012 17:22:29 -0400 (EDT)

> From: Florian Fainelli <florian@openwrt.org>
> Date: Tue, 29 May 2012 11:20:50 +0200
> 
>> On Monday 28 May 2012 17:27:03 Devendra Naga wrote:
>>> the calls after the pci_enable_device may fail, and will error out with out
>>> disabling it. disable the device at error paths.
>> 
>> Looks good, thanks Devendra!
>> 
>>> 
>>> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
>> 
>> Acked-by: Florian Fainelli <florian@openwrt.org>
> 
> Applied.

Actually, reverted, you didn't test this patch at all.

You didn't even look at the warnings emitted by the compiler
with your changes installed.

You're passing a network device pointer into the PCI device
disable routine, which takes a PCI device pointer.

I can't express to you how extremely irritating it is when
people submit patches like this.

The bug in question is 1,000 times less harmful than your fix.
