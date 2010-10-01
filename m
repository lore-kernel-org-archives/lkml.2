Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0JATkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 15:40:15 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58063 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab0JATkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 15:40:12 -0400
Date: Fri, 1 Oct 2010 14:39:58 -0500
From: Robin Holt <holt@sgi.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Vlad Yasevich <vladislav.yasevich@hp.com>,
        Sridhar Samudrala <sri@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net, linux-sctp@vger.kernel.org
Subject: sysctl_{tcp,udp,sctp}_mem overflow on 16TB system.
Message-ID: <20101001193958.GP14068@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On a 16TB system, we noticed that sysctl_tcp_mem[2] and sysctl_udp_mem[2]
were negative.  Code review indicates that the same should occur with
sysctl_sctp_mem[2].

There are a couple ways we could address this.  The one which appears most
reasonable would be to change the struct proto defintion for sysctl_mem
from an int to a long and handle all the associated fallout.

An alternative is to limit the calculation to 1/2 INT_MAX.  The downside
being that the administrator could not tune the system to use more than
INT_MAX memory when much more is available.

Is there a compelling reason to not change the structure's definition
over to longs instead of ints and deal with the fallout from that change?

Thanks,
Robin Holt
