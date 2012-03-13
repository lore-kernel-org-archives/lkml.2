Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759778Ab2CMF5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:57:36 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55950 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759751Ab2CMF5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:57:34 -0400
Date: Mon, 12 Mar 2012 22:53:02 -0700 (PDT)
Message-Id: <20120312.225302.488696931454771146.davem@davemloft.net>
To: apenwarr@gmail.com
Cc: akpm@linux-foundation.org, josh@joshtriplett.org,
        paulmck@linux.vnet.ibm.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        fdinitto@redhat.com, hannes@cmpxchg.org, olaf@aepfle.de,
        paul.gortmaker@windriver.com, tj@kernel.org, hpa@linux.intel.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/5] Persist printk buffer across reboots.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
References: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 12 Mar 2012 22:53:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avery Pennarun <apenwarr@gmail.com>
Date: Tue, 13 Mar 2012 01:36:36 -0400

> The last patch in this series implements a new CONFIG_PRINTK_PERSIST option
> that, when enabled, puts the printk buffer in a well-defined memory location
> so that we can keep appending to it after a reboot.  The upshot is that,
> even after a kernel panic or non-panic hard lockup, on the next boot
> userspace will be able to grab the kernel messages leading up to it.  It
> could then upload the messages to a server (for example) to keep crash
> statistics.

On some platforms there are formal ways to reserve areas of memory
such that the bootup firmware will know to not touch it on soft resets
no matter what.  For example, on Sparc there are OpenFirmware calls to
set aside such an area of soft-reset preserved memory.

I think some formal agreement with the system firmware is a lot better
when available, and should be explicitly accomodated in these changes
so that those of us with such facilities can very easily hook it up.
