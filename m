Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab2ILHtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 03:49:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53741 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab2ILHtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 03:49:07 -0400
Date: Wed, 12 Sep 2012 03:49:01 -0400 (EDT)
Message-Id: <20120912.034901.184817520125489015.davem@davemloft.net>
To: srivatsa.bhat@linux.vnet.ibm.com
Cc: nhorman@tuxdriver.com, David.Laight@aculab.com, john.r.fastabend@intel.com,
        gaofeng@cn.fujitsu.com, eric.dumazet@gmail.com,
        mark.d.rustad@intel.com, lizefan@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH 2/2] netprio_cgroup: Use memcpy instead of the
 for-loop to copy priomap
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120912060747.11037.42623.stgit@srivatsabhat.in.ibm.com>
References: <20120912060741.11037.37347.stgit@srivatsabhat.in.ibm.com>
	<20120912060747.11037.42623.stgit@srivatsabhat.in.ibm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Wed, 12 Sep 2012 11:37:47 +0530

> +		memcpy(new_priomap->priomap, old_priomap->priomap,
> +			old_priomap->priomap_len *
> +					sizeof(old_priomap->priomap[0]));

This argument indentation is ridiculous.  Try:

		memcpy(new_priomap->priomap, old_priomap->priomap,
		       old_priomap->priomap_len *
		       sizeof(old_priomap->priomap[0]));

Using TABs exclusively for argumentat indentation is not the goal.

Rather, lining the arguments up properly so that they sit at the first
column after the first line's openning parenthesis is what you should
be trying to achieve.

And ignoring whatever stylistic convention we may or may not have, I
find it impossibly hard to believe that the code quoted above looks
good even to you.

