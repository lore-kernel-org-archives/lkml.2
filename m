Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab1KVU4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:56:04 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53841 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab1KVU4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:56:02 -0500
Date: Tue, 22 Nov 2011 15:55:57 -0500 (EST)
Message-Id: <20111122.155557.1954460980055957565.davem@davemloft.net>
To: michael@alpha-unix.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernelpanic on eeePC and MSI Wind (both using rt2800pci) with
 Linux 3.x
From: David Miller <davem@davemloft.net>
In-Reply-To: <jah1te$h33$1@dough.gmane.org>
References: <j978hu$i23$1@dough.gmane.org>
	<j9o412$oum$1@dough.gmane.org>
	<jah1te$h33$1@dough.gmane.org>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 22 Nov 2011 12:55:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Basse <michael@alpha-unix.de>
Date: Tue, 22 Nov 2011 21:49:49 +0100

> Hi,
> 
> just for the record. This thread is hopefully providing a patch
> 
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/80759
> 
> already built the kernel and doing some testing now.

That patch is wrong, it returns IRQ_HANDLED when it can't tell if the
chip generated the interrupt or not.

Therefore, if any other device shares that interrupt line it's
interrupts can be lost when this case triggers.

This has to be fixed another way.
