Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab1DGWaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:30:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51818
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755867Ab1DGWaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:30:14 -0400
Date: Thu, 07 Apr 2011 15:29:37 -0700 (PDT)
Message-Id: <20110407.152937.59699180.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, bheglaas@google.com, monstr@monstr.eu,
        tglx@linuxtronix.de, bigeasy@linuxtronix.de
Subject: Re: [PATCH 1/5] pci/of: Match PCI devices to OF nodes dynamically
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110407.152707.39195948.davem@davemloft.net>
References: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
	<1302146796-26825-2-git-send-email-benh@kernel.crashing.org>
	<20110407.152707.39195948.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 07 Apr 2011 15:27:07 -0700 (PDT)

> However, of_pci_find_child_device() lives in drivers/of/of_pci.c which is not
> built into the tree because you haven't provided the necessary changes to
> drivers/of/Makefile in this patch.

Oh I see, it exists already but it's only built into the tree for
microblaze, x86, and ppc.

There's a lot of stuff in there which is superfluous and will never
be used on sparc.

Everything in there except the new of_pci_find_child_device() function
will be never ever used on sparc and therefore dead code.
