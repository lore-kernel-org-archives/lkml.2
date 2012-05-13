Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289Ab2EMEMA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 00:12:00 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45990 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab2EMEL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 00:11:59 -0400
Date: Sun, 13 May 2012 00:10:49 -0400 (EDT)
Message-Id: <20120513.001049.1690048451766768688.davem@davemloft.net>
To: tglx@linutronix.de
CC: linux-kernel@vger.kernel.org
Subject: allmodconfig build broken by gpio changes
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 12 May 2012 21:10:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You can't reference handle_edge_irq in the pch9 driver, since pch9 can
be built modular yet handle_edge_irq is not exported to modules.

I assume allmodconfig is part of your standard validation procedures,
so I'm really surprised this made it all the way to Linus's tree :-)
