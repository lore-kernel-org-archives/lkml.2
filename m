Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab0JAUdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 16:33:10 -0400
Received: from 1wt.eu ([62.212.114.60]:45837 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096Ab0JAUdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 16:33:08 -0400
Date: Fri, 1 Oct 2010 22:30:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: Robin Holt <holt@sgi.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Vlad Yasevich <vladislav.yasevich@hp.com>,
        Sridhar Samudrala <sri@us.ibm.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net,
        linux-sctp@vger.kernel.org
Subject: Re: sysctl_{tcp,udp,sctp}_mem overflow on 16TB system.
Message-ID: <20101001203022.GA28486@1wt.eu>
References: <20101001193958.GP14068@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101001193958.GP14068@sgi.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Robin,

On Fri, Oct 01, 2010 at 02:39:58PM -0500, Robin Holt wrote:
> 
> On a 16TB system, we noticed that sysctl_tcp_mem[2] and sysctl_udp_mem[2]
> were negative.  Code review indicates that the same should occur with
> sysctl_sctp_mem[2].
> 
> There are a couple ways we could address this.  The one which appears most
> reasonable would be to change the struct proto defintion for sysctl_mem
> from an int to a long and handle all the associated fallout.
> 
> An alternative is to limit the calculation to 1/2 INT_MAX.  The downside
> being that the administrator could not tune the system to use more than
> INT_MAX memory when much more is available.
> 
> Is there a compelling reason to not change the structure's definition
> over to longs instead of ints and deal with the fallout from that change?

Could we not see it differently ? => is there any reason someone would
want to assign more than 8 TB of RAM to the network buffers in the near
future ? Even at 100 Gbps, that's still 10 minutes of traffic stuck in
buffers. Probably that the day we need that large buffers, Linux won't
support 32-bit systems anymore and all such limits will have switched
to 64-bit.

So probably that limiting the value to INT_MAX/2 sounds reasonable ?

Regards,
Willy

