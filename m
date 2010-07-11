Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0GKCgV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 22:36:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37805
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125Ab0GKCgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 22:36:20 -0400
Date: Sat, 10 Jul 2010 19:36:34 -0700 (PDT)
Message-Id: <20100710.193634.229744909.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       henning.fehrmann@aei.mpg.de, carsten.aulbert@aei.mpg.de
Subject: Re: oops in tcp_xmit_retransmit_queue() w/ v2.6.32.15
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C358AAA.9080400@kernel.org>
References: <4C358AAA.9080400@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Thu, 08 Jul 2010 10:22:02 +0200

> We've been seeing oops in tcp_xmit_retransmit_queue() w/ 2.6.32.15.
 ...
> Does anything ring a bell?

A long time ago we had a packet scheduler bug that could corrupt
the TCP socket queues, but that was fixed in 2.6.27 so would
definitely be fixed in your kernel.

--------------------
commit 69747650c814a8a79fef412c7416adf823293a3e
Author: David S. Miller <davem@davemloft.net>
Date:   Sun Aug 17 23:55:36 2008 -0700

    pkt_sched: Fix return value corruption in HTB and TBF.
    
    Based upon a bug report by Josip Rodin.
    
    Packet schedulers should only return NET_XMIT_DROP iff
    the packet really was dropped.  If the packet does reach
    the device after we return NET_XMIT_DROP then TCP can
    crash because it depends upon the enqueue path return
    values being accurate.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>
--------------------

Nothing else jumps to mind, sorry.
