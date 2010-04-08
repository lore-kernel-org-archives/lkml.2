Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485Ab0DHHF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 03:05:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34885
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758444Ab0DHHFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 03:05:54 -0400
Date: Thu, 08 Apr 2010 00:05:57 -0700 (PDT)
Message-Id: <20100408.000557.180546976.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: yanmin_zhang@linux.intel.com, cl@linux-foundation.org,
       penberg@cs.helsinki.fi, netdev@vger.kernel.org, tj@kernel.org,
       alex.shi@intel.com, linux-kernel@vger.kernel.org, ling.ma@intel.com,
       tim.c.chen@intel.com, akpm@linux-foundation.org
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
From: David Miller <davem@davemloft.net>
In-Reply-To: <1270710019.2215.4.camel@edumazet-laptop>
References: <1270702774.8141.49.camel@edumazet-laptop>
	<1270705153.8141.58.camel@edumazet-laptop>
	<1270710019.2215.4.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 08 Apr 2010 09:00:19 +0200

> If run individually, the tests results are more what we would expect
> (slow), but if machine runs the two set of process concurrently, each
> group runs much faster...

BTW, I just discovered (thanks to the function graph tracer, woo hoo!)
that loopback TCP packets get fully checksum validated on receive.

I'm trying to figure out why skb->ip_summed ends up being
CHECKSUM_NONE in tcp_v4_rcv() even though it gets set to
CHECKSUM_PARTIAL in tcp_sendmsg().

I wonder how much this accounts for some of the hackbench
oddities... and other regressions in loopback tests we've seen.
:-)

Just FYI...
