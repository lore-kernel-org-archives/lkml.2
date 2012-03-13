Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab2CMGyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:54:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56385 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab2CMGyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:54:16 -0400
Date: Mon, 12 Mar 2012 23:50:02 -0700 (PDT)
Message-Id: <20120312.235002.344576347742686103.davem@davemloft.net>
To: apenwarr@gmail.com
Cc: akpm@linux-foundation.org, josh@joshtriplett.org,
        paulmck@linux.vnet.ibm.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        fdinitto@redhat.com, hannes@cmpxchg.org, olaf@aepfle.de,
        paul.gortmaker@windriver.com, tj@kernel.org, hpa@linux.intel.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/5] Persist printk buffer across reboots.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAHqTa-3DiZhd_yoRTzp2Np0Rp=_zrfL7CbN_twu+ZZeu7f4ENg@mail.gmail.com>
References: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
	<20120312.225302.488696931454771146.davem@davemloft.net>
	<CAHqTa-3DiZhd_yoRTzp2Np0Rp=_zrfL7CbN_twu+ZZeu7f4ENg@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 12 Mar 2012 23:50:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avery Pennarun <apenwarr@gmail.com>
Date: Tue, 13 Mar 2012 02:00:30 -0400

> Sounds good to me.  Do you have any pointers?  Just use an
> early_param?  If we see the early_param but we can't reserve the
> requested address, should we fall back to probing or disable the
> PRINTK_PERSIST mode entirely?

The interface is prom_retain() in f.e. arch/sparc/prom/misc_64.c

You give it a string name, a size in bytes, and an alignment.  And you
are given a physical address on success.  I'm pretty sure the string
name you give is one of the keys it uses to look up the same piece of
memory for you next time.  So you can have retained memory across soft
resets not just for log buffers, but for other things too.

The idea is that you call prom_retain() before you take a look at what
physical memory is available in the kernel, and the firmware takes
this physical chunk out of those available memory lists upon
prom_retain() success.

