Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1HOViU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 17:38:20 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43444 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1HOViQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 17:38:16 -0400
Date: Mon, 15 Aug 2011 14:37:10 -0700 (PDT)
Message-Id: <20110815.143710.1173702549295979935.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,v2] sparc32: unbreak arch_write_unlock()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20041.32134.131376.866324@pilspetsen.it.uu.se>
References: <20041.32134.131376.866324@pilspetsen.it.uu.se>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 15 Aug 2011 14:37:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Mon, 15 Aug 2011 22:11:50 +0200

> The sparc32 version of arch_write_unlock() is just a plain assignment.
> Unfortunately this allows the compiler to schedule side-effects in a
> protected region to occur after the HW-level unlock, which is broken.
> E.g., the following trivial test case gets miscompiled:
> 
> 	#include <linux/spinlock.h>
> 	rwlock_t lock;
> 	int counter;
> 	void foo(void) { write_lock(&lock); ++counter; write_unlock(&lock); }
> 
> Fixed by adding a compiler memory barrier to arch_write_unlock().  The
> sparc64 version combines the barrier and assignment into a single asm(),
> and implements the operation as a static inline, so that's what I did too.
> 
> Compile-tested with sparc32_defconfig + CONFIG_SMP=y.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

Applied.
