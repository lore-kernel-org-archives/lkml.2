Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab2A0MrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 07:47:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41111 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298Ab2A0MrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 07:47:07 -0500
Date: Fri, 27 Jan 2012 13:46:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: [v3.3-rc1 regression] TCP: too many of orphaned sockets
Message-ID: <20120127124641.GA30819@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There's a new TCP regression in latest -git that triggers in 
randconfig testing.

With the attached config i'm getting tons of these messages:

[   32.751209] TCP: too many of orphaned sockets                                                   
[   37.198307] TCP: too many of orphaned sockets                                                   
[   42.464404] TCP: too many of orphaned sockets                                                   
[   48.920392] TCP: too many of orphaned sockets                                                   
[   56.370026] TCP: too many of orphaned sockets                                                   
[   64.605937] TCP: too many of orphaned sockets                     

and it's not possible to ssh into the testbox, the TCP 
connection hangs.

Before i put more effort into debugging this, is this bug 
already known/fixed?

NOTE: the .config is randconfig generated so it might have a few 
weird combinations of config options. One such thing i noticed 
is !CONFIG_BUG, this produces at least one of the following 
build warnings in the networking code:

net/core/ethtool.c:211:1: warning: control reaches end of non-void function [-Wreturn-type]
net/core/dev.c:1892:33: warning: unused variable ‘null_features’ [-Wunused-variable]
net/packet/af_packet.c:1878:30: warning: ‘hdrlen’ may be used uninitialized in this function [-Wmaybe-uninitialized]
net/xfrm/xfrm_policy.c:2456:17: warning: ‘xfrm_dst_ops’ may be used uninitialized in this function [-Wmaybe-uninitialized]
net/xfrm/xfrm_policy.c:1351:7: warning: ‘dst_ops’ may be used uninitialized in this function [-Wmaybe-uninitialized]
net/xfrm/xfrm_policy.c:1333:18: note: ‘dst_ops’ was declared here
net/xfrm/xfrm_policy.c:1351:7: warning: ‘dst_ops’ may be used uninitialized in this function [-Wmaybe-uninitialized]
net/xfrm/xfrm_policy.c:1333:18: note: ‘dst_ops’ was declared here

Note#2, the message should probably be fixed as well:

 -   TCP: too many of orphaned sockets                     
 +   TCP: too many orphaned sockets                     

Thanks,

	Ingo
