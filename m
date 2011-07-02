Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab1GBAbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 20:31:09 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38482 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab1GBAbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 20:31:08 -0400
Date: Fri, 01 Jul 2011 17:30:57 -0700 (PDT)
Message-Id: <20110701.173057.2255930046909364966.davem@davemloft.net>
To: arnd@arndb.de
Cc: f6bvp@free.fr, ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-hams@vger.kernel.org
Subject: Re: [PATCH] 6pack,mkiss: fix lock inconsistency
From: David Miller <davem@davemloft.net>
In-Reply-To: <201107012328.46256.arnd@arndb.de>
References: <20110625163942.GB20976@linux-mips.org>
	<4E0DC4F3.6010203@free.fr>
	<201107012328.46256.arnd@arndb.de>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 01 Jul 2011 17:30:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 1 Jul 2011 23:28:46 +0200

> Lockdep found a locking inconsistency in the mkiss_close function:
> 
>> kernel: [ INFO: inconsistent lock state ]
>> kernel: 2.6.39.1 #3
>> kernel: ---------------------------------
>> kernel: inconsistent {IN-SOFTIRQ-R} -> {SOFTIRQ-ON-W} usage.
>> kernel: ax25ipd/2813 [HC0[0]:SC0[0]:HE1:SE1] takes:
>> kernel: (disc_data_lock){+++?.-}, at: [<ffffffffa018552b>] mkiss_close+0x1b/0x90 [mkiss]
>> kernel: {IN-SOFTIRQ-R} state was registered at:
> 
> The message hints that disc_data_lock is aquired with softirqs disabled,
> but does not itself disable softirqs, which can in rare circumstances
> lead to a deadlock. 
> The same problem is present in the 6pack driver, this patch fixes both
> by using write_lock_bh instead of write_lock.
> 
> Reported-by: Bernard F6BVP <f6bvp@free.fr>
> Tested-by: Bernard F6BVP <f6bvp@free.fr>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Ralf Baechle<ralf@linux-mips.org>
> Cc: stable@kernel.org

Applied, thanks!
